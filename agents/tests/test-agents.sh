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
cleanup() { [ -n "${fake_foot:-}" ] && kill "$fake_foot" 2>/dev/null; rm -rf "$tmp"; }
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
chmod +x "$tmp/bin/"*

export PATH="$tmp/bin:$pkg/.local/bin:$PATH"
export HYPRCTL_LOG="$tmp/hyprctl.log" CLIENTS_JSON="$tmp/clients.json"
export DUNST_LOG="$tmp/dunst.log" PKILL_LOG="$tmp/pkill.log"
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
printf '[{"pid":%s,"address":"0x55aa0000"}]' "$c1pid" > "$CLIENTS_JSON"
assert_eq "c1 pid = its foot terminal" "$c1pid" "$(cat "$tmp/c1pid")"
dispatches_before=$(grep -c dispatch "$HYPRCTL_LOG")
STUB_DUNST_ACTION=default agent-notify c1 critical "claude · x" "msg"
wait_for 'dispatch focuswindow address:0x55aa0000' "$HYPRCTL_LOG" \
    || fail "click must resolve pid→address and focus the window"
assert_eq "exactly one focus dispatch" "$(grep -c dispatch "$HYPRCTL_LOG")" "$((dispatches_before + 1))"

echo "ALL PASS"
