#!/bin/bash
# Assert-based test for the agents spine (agent-hook / agent-notify /
# focus-window). External behavior only: state-dir contents and the call logs
# of stubbed dunstify / hyprctl / pkill. A copy of bash named "foot" plays the
# standalone foot terminal so the PPID walk is exercised for real.
#
# Run: bash agents/tests/test-agents.sh

set -u
here=$(cd "$(dirname "$0")" && pwd)
pkg=$(dirname "$here")

tmp=$(mktemp -d)
cleanup() {
    [ -n "${fake_foot:-}" ] && kill "$fake_foot" 2>/dev/null
    [ -n "${live_pid:-}" ]  && kill "$live_pid" 2>/dev/null
    [ -n "${live2_pid:-}" ] && kill "$live2_pid" 2>/dev/null
    rm -rf "$tmp"
}
trap cleanup EXIT

export XDG_RUNTIME_DIR="$tmp/runtime"
mkdir -p "$XDG_RUNTIME_DIR/agents" "$tmp/bin"

# --- stubs -----------------------------------------------------------------
cat > "$tmp/bin/hyprctl" <<'EOF'
#!/bin/bash
echo "hyprctl $*" >> "$HYPRCTL_LOG"
[ "$1" = clients ] && cat "$CLIENTS_JSON"
exit 0
EOF
cat > "$tmp/bin/dunstify" <<'EOF'
#!/bin/bash
echo "dunstify $*" >> "$DUNST_LOG"
# simulate a click: print the action name dunst would report
[ -n "$STUB_DUNST_ACTION" ] && echo "$STUB_DUNST_ACTION"
exit 0
EOF
cat > "$tmp/bin/pkill" <<'EOF'
#!/bin/bash
echo "pkill $*" >> "$PKILL_LOG"
exit 0
EOF
cat > "$tmp/bin/dmenu" <<'EOF'
#!/bin/bash
# log the offered lines, print the fake user's choice
(cat >> "$DMENU_LOG"; echo "$STUB_DMENU_CHOICE")
exit 0
EOF
chmod +x "$tmp/bin/"*

export PATH="$tmp/bin:$pkg/.local/bin:$PATH"
export HYPRCTL_LOG="$tmp/hyprctl.log" CLIENTS_JSON="$tmp/clients.json"
export DUNST_LOG="$tmp/dunst.log" PKILL_LOG="$tmp/pkill.log"
export DMENU_LOG="$tmp/dmenu.log"; : > "$DMENU_LOG"
: > "$HYPRCTL_LOG"; : > "$DUNST_LOG"; : > "$PKILL_LOG"

# fake standalone foot: a bash binary named "foot" (comm = "foot"), so the
# PPID walk in agent-hook finds it as the nearest "foot" ancestor
cp "$(command -v bash)" "$tmp/bin/foot"

# --- helpers ----------------------------------------------------------------
fail() { echo "FAIL: $*" >&2; exit 1; }
ok()   { echo "ok: $*"; }
assert_eq() { [ "$2" = "$3" ] && ok "$1" || fail "$1 — got '$2', want '$3'"; }
wait_for()  # <text> <file>: poll until the text shows up in the file
{ for _ in $(seq 1 50); do grep -q -- "$1" "$2" 2>/dev/null && return 0; sleep 0.1; done; return 1; }

session_json='{"session_id":"s1","cwd":"/home/user/dotfiles","message":"needs approval"}'
FAKEPID_FILE="$tmp/fakepid" SESSION_JSON="$session_json" \
    "$tmp/bin/foot" -c 'echo $$ > "$FAKEPID_FILE"; agent-hook claude notify <<<"$SESSION_JSON"; true' &
fake_foot=$!

# --- notify event writes full state ----------------------------------------
state="$XDG_RUNTIME_DIR/agents/s1.json"
wait_for 'claude' "$DUNST_LOG" || fail "no notification for notify event"
fake_pid=$(cat "$tmp/fakepid")
assert_eq "agent"       "$(jq -r .agent    "$state")" claude
assert_eq "project"     "$(jq -r .project  "$state")" dotfiles
assert_eq "cwd"         "$(jq -r .cwd      "$state")" /home/user/dotfiles
assert_eq "event"       "$(jq -r .event    "$state")" notify
assert_eq "message"     "$(jq -r .message  "$state")" "needs approval"
assert_eq "pid = terminal PID (PPID walk)" "$(jq -r .pid "$state")" "$fake_pid"
ts=$(jq -r .ts "$state"); case $ts in *[!0-9]*|'') fail "ts not numeric: '$ts'";; *) ok "ts numeric";; esac

grep -q -- '-u critical' "$DUNST_LOG"      || fail "notify must be critical urgency"
grep -q -- '--stack-tag s1' "$DUNST_LOG"   || fail "notification must carry the session stack tag"
grep -q -- '-RTMIN+8 -x waybar' "$PKILL_LOG" || fail "waybar not signalled"

# --- done event replaces state, notifies normal ------------------------------
echo '{"session_id":"s1","cwd":"/home/user/dotfiles","message":"finished"}' | agent-hook claude done
assert_eq "done: event" "$(jq -r .event "$state")" done
wait_for '-u normal' "$DUNST_LOG" || fail "done must notify with normal urgency"
n=$(find "$XDG_RUNTIME_DIR/agents" -name 's1*' | wc -l)
assert_eq "one state file per session" "$n" 1

# --- working event: state only, no new notification --------------------------
before=$(wc -l < "$DUNST_LOG")
echo '{"session_id":"s1"}' | agent-hook claude working
assert_eq "working: event" "$(jq -r .event "$state")" working
sleep 0.3   # a backgrounded stray helper would land in the log by now
assert_eq "working: no notification" "$(wc -l < "$DUNST_LOG")" "$before"

# --- clear event removes the state file ---------------------------------------
echo '{"session_id":"s1"}' | agent-hook claude clear
[ -e "$state" ] && fail "clear must remove the state file" || ok "clear removes state file"

# --- parallel writers: one file each, no contention ---------------------------
echo '{"session_id":"a"}' | agent-hook claude notify &
echo '{"session_id":"b"}' | agent-hook claude done &
wait
wait_for 'b' "$DUNST_LOG" || fail "session b never notified"
for s in a b; do
    [ -e "$XDG_RUNTIME_DIR/agents/$s.json" ] || fail "missing state file for session $s"
done
ok "parallel writers: one file per session"

# --- click through: notification action → focus-window → hyprctl -------------
FAKEPID_FILE="$tmp/c1pid" SESSION_JSON='{"session_id":"c1","cwd":"/tmp/x"}' \
    "$tmp/bin/foot" -c 'echo $$ > "$FAKEPID_FILE"; agent-hook claude notify <<<"$SESSION_JSON"; true' &
c1state="$XDG_RUNTIME_DIR/agents/c1.json"
wait_for 'c1' "$DUNST_LOG" || fail "no notification for c1"
c1pid=$(jq -r .pid "$c1state")
assert_eq "c1 pid = its foot terminal" "$c1pid" "$(cat "$tmp/c1pid")"
dispatches_before=$(grep -c dispatch "$HYPRCTL_LOG")
STUB_DUNST_ACTION=default agent-notify c1 critical "claude · x" "msg"
wait_for "dispatch hl.dsp.focus({ window = 'pid:$c1pid' })" "$HYPRCTL_LOG" \
    || fail "click must dispatch a pid-selector focus for the session's window"
assert_eq "exactly one focus dispatch" "$(grep -c dispatch "$HYPRCTL_LOG")" "$((dispatches_before + 1))"

# --- widget: fixture state dir → waybar JSON contract -------------------------
rm -f "$XDG_RUNTIME_DIR/agents"/*.json
sleep 300 & live_pid=$!
bash -c 'exit 0' & dead_pid=$!; wait "$dead_pid"

mk_state() {  # <sid> <event> <pid> <agent> <project>
    jq -n --arg agent "$4" --arg project "$5" --arg event "$2" \
          --argjson pid "$3" --argjson ts 1 --arg message m \
          '{agent:$agent,project:$project,cwd:"/x",event:$event,pid:$pid,ts:$ts,message:$message}' \
          > "$XDG_RUNTIME_DIR/agents/$1.json"
}

mk_state w1 working "$live_pid"  pi      other
mk_state n1 notify  "$live_pid"  pi      dotfiles
mk_state d1 done    "$live_pid"  claude  dotfiles
mk_state x1 done    "$dead_pid"  opencode ghost
mk_state z1 notify  0            opencode nopid   # pid 0 = terminal not found → kept, still listed

out=$(SHOW_ZERO=1 agents-widget)
assert_eq "widget counts notify+done, not working" "$(jq -r .text <<<"$out")" 3
assert_eq "widget class: a notify session outranks done" "$(jq -r .class <<<"$out")" notify
tooltip=$(jq -r .tooltip <<<"$out")
grep -q 'pi · dotfiles — czeka'     <<<"$tooltip" || fail "tooltip: notify line missing — $tooltip"
grep -q 'claude · dotfiles — gotowe' <<<"$tooltip" || fail "tooltip: done line missing — $tooltip"
grep -q 'opencode · nopid — czeka'  <<<"$tooltip" || fail "pid-0 session must be listed — $tooltip"
grep -q ghost <<<"$tooltip" && fail "dead-pid session must not be listed"
grep -q other <<<"$tooltip" && fail "working session must not be listed"
[ -e "$XDG_RUNTIME_DIR/agents/x1.json" ] && fail "dead pid must be pruned at render"
[ -e "$XDG_RUNTIME_DIR/agents/w1.json" ] || fail "live working session must survive pruning"
[ -e "$XDG_RUNTIME_DIR/agents/z1.json" ] || fail "pid-0 session must survive (not dead, just unclickable)"

# --- zero toggle: one variable in the script, no waybar config edit ----------
rm -f "$XDG_RUNTIME_DIR/agents"/*.json
assert_eq "SHOW_ZERO=1 → always visible 0" "$(SHOW_ZERO=1 agents-widget | jq -r .text)" 0
assert_eq "SHOW_ZERO=0 → hidden (empty text, waybar collapses it)" "$(SHOW_ZERO=0 agents-widget | jq -r .text)" ""

# --- picker: dmenu lines from state file + focus through stub hyprctl --------
rm -f "$XDG_RUNTIME_DIR/agents"/*.json
sleep 300 & live2_pid=$!
mk_state p1 notify "$live_pid"  pi     pickproj
mk_state q1 done   "$live_pid"  claude twin
mk_state q2 done   "$live2_pid" claude twin   # same agent+project → must be told apart by pid

lines=$(agents-widget lines)
assert_eq "dmenu line format" "$(awk -F'\t' '$2 == "pi · pickproj (czeka)" {print $2}' <<<"$lines")" "pi · pickproj (czeka)"
grep -q "^$live_pid" <<<"$lines" || fail "picker row must carry the window pid"

: > "$HYPRCTL_LOG"; : > "$DMENU_LOG"
STUB_DMENU_CHOICE="pi · pickproj (czeka)" agents-pick
wait_for "dispatch hl.dsp.focus({ window = 'pid:$live_pid' })" "$HYPRCTL_LOG" \
    || fail "picking a session must focus its window"
grep -qF "claude · twin (gotowe) [#$live_pid]"  "$DMENU_LOG" || fail "duplicate labels must carry a pid suffix"
grep -qF "claude · twin (gotowe) [#$live2_pid]" "$DMENU_LOG" || fail "duplicate labels must carry a pid suffix"

: > "$HYPRCTL_LOG"
STUB_DMENU_CHOICE="claude · twin (gotowe) [#$live2_pid]" agents-pick
wait_for "dispatch hl.dsp.focus({ window = 'pid:$live2_pid' })" "$HYPRCTL_LOG" \
    || fail "picking a disambiguated twin must focus the right window"

# --- waybar config contract: signal-driven, no polling ------------------------
wbconf=$pkg/../waybar/.config/waybar/config.jsonc
[ -f "$wbconf" ] || fail "waybar config not found: $wbconf"
for want in '"custom/agents"' '"signal": 8' '"interval": "once"' \
            '"hide-empty-text": true' '"on-click": "~/.local/bin/agents-pick"'; do
    grep -q "$want" "$wbconf" || fail "waybar config missing: $want"
done
ok "waybar module wired: signal 8, interval once, click → agents-pick"

echo "ALL PASS"
