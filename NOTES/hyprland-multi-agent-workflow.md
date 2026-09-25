# Hyprland multi-agent workflow: notifications + waybar widget with click-to-focus

Research notes for: Hyprland + foot + waybar, running Claude Code / opencode / pi concurrently.
Goal: (1) clickable notification that focuses the agent's window, (2) waybar widget counting
waiting/finished agents with a click-to-focus list, (3) whatever Omarchy showed on YouTube.

All claims cite a primary source (official docs / man pages / repo source / local files).
Inferences are labeled. "Could not verify" items are listed at the end.

---

## 1. Recommended architecture

```
agent (Claude Code / opencode / pi)
   │  hook / plugin / extension fires on "needs input" / "finished"
   ▼
agent-hook.sh  ── writes one JSON state file per session ──▶  ${XDG_RUNTIME_DIR}/agents/<session_id>.json
   │                                                          {agent, project, cwd, event, ts, title}
   ├─ dunstify --action "focus,<project>"   (clickable notification)
   │        └─ dunst mouse_left_click = do_action → runs the action's command
   │
   └─ pkill -RTMIN+8 waybar                 (nudge the widget NOW)
                │
                ▼
   waybar custom/agents  (signal-driven, return-type json, reads the state dir)
        on-click → opens a picker (menu XML or dmenu) listing waiting agents
                   each entry → focus-window.sh <title-or-address>
                                    │
                                    ▼
                     hyprctl dispatch focuswindow address:0x…  (or title:/class: regex)
```

State = plain files in `${XDG_RUNTIME_DIR}` (tmpfs, auto-cleaned, no daemon, concurrent writers
never contend). This is the same design as the `agent-status` crate
([paulvandermeijs/agent-status](https://github.com/paulvandermeijs/agent-status) — see §8),
whose README explicitly documents it: *"No daemon. The filesystem is the state store; each
session writes only its own keyed file, so concurrent writers never contend."*

Window correlation: every agent terminal gets a **unique, stable window title** at launch
(`foot -T …`, see §3). The state file records it; `focus-window.sh` resolves the title to a
window address via `hyprctl clients -j` at click time (addresses are volatile — always
re-resolve, never store them long-term; see §2.1).

---

## 2. Window focusing on Hyprland

### 2.1 `focuswindow` syntax (official wiki, current)

From [Dispatchers — Hyprland Wiki](https://wiki.hypr.land/Configuring/Basics/Dispatchers/):

> `focuswindow` — focuses the first window matching — `window`

The `window` parameter, verbatim from the same page:

> A window. Can be:
> - window object
> - regexes: `class:...`, `initialclass:...`, `title:...`, `initialtitle:...`, `tag:...`
> - exact selectors: `pid:...`, `stableid:...`, `address:0x...`
> - `activewindow` / `floating` / `tiled`

So:

```bash
hyprctl dispatch focuswindow address:0x55f3409ea330   # exact, always unique
hyprctl dispatch focuswindow title:^(pi · dotfiles)$  # title regex
hyprctl dispatch focuswindow class:^foot$             # first foot window only — NOT per-instance
```

Caveats:
- **`class:` matches only the first window** — useless when all your terminals are `foot`.
  Use `title:` or `address:` for a specific foot instance.
- Older Hyprland versions had a bug where `title:`/`class:` regexes were accepted by
  `windowrulev2` but not by `dispatch` ([hyprwm/Hyprland#4289](https://github.com/hyprwm/Hyprland/issues/4289),
  2024). The current wiki documents them as supported. **Recommendation: resolve to an
  `address:` and focus by address** — a Hyprland maintainer-adjacent discussion also notes
  "you might prefer using the address as it will ALWAYS be unique"
  ([discussion #830](https://github.com/hyprwm/Hyprland/discussions/830)). Works on every version.

### 2.2 Enumerating windows / finding the address

From [Using hyprctl — Hyprland Wiki](https://wiki.hypr.land/Configuring/Advanced-and-Cool/Using-hyprctl/):

> `clients` - lists all windows with their properties
> `activewindow` - gets the active window name and its properties

And the flags section shows `hyprctl -j monitors` — the `-j` flag makes any info command emit
JSON. So the canonical way to find a window's address by title:

```bash
hyprctl clients -j | jq -r '.[] | select(.title | test("pi · dotfiles")) | .address'
# → "0x55f3409ea330"
```

The wiki also warns: *"hyprctl calls will be dispatched by the compositor synchronously,
meaning any spam of the utility will cause slowdowns. It's recommended to use `--batch` for
many control calls, and limiting the amount of info calls."* Your click-handler runs once per
click — fine. Don't poll `clients -j` in a tight loop.

`stableid:...` (in the selector list above) is a newer persistent window id — useful if your
Hyprland is new enough to have it; `address:` is the portable choice.

### 2.3 Window rules (matching a specific foot window)

⚠️ **Version warning, verified from the wiki itself**: the current
[Window Rules page](https://wiki.hypr.land/Configuring/Basics/Window-Rules/) says *"Looking for
the old hyprlang syntax? Check the 0.54 wiki pages. Since Hyprland 0.55, hyprlang is deprecated
in favor of lua."* Run `hyprctl version` and use the matching wiki (the wiki is versioned via
the version selector — [wiki.hypr.land](https://wiki.hypr.land)).

For Hyprland ≤ 0.47 (the syntax most configs in the wild use), from
[Window Rules — Hyprland Wiki 0.47.0](https://wiki.hyprland.org/0.47.0/Configuring/Window-Rules/):

> In V2, you are allowed to match multiple variables. the RULE field is unchanged, but in the
> WINDOW field, you can put regexes for multiple values like so:
> `windowrulev2 = float, class:kitty, title:kitty`

For 0.54 the syntax became
`windowrule = match:class my-window, border_size 10`
([0.54.0 Window Rules](https://wiki.hypr.land/0.54.0/Configuring/Window-Rules/)); 0.55+ uses Lua
(`hl.window_rule({...})`, see current page). Example (classic syntax) — give agent terminals a
distinct border color so waiting agents are visible even without waybar:

```ini
windowrulev2 = bordersize 3, class:^(foot)$, title:^(ai · .*)$
```

### 2.4 Hyprland event socket (live window registry)

From [IPC — Hyprland Wiki](https://wiki.hypr.land/IPC/):

> Hyprland exposes 2 UNIX Sockets …
> `$XDG_RUNTIME_DIR/hypr/[HIS]/.socket.sock` — Used for hyprctl-like requests.
> `$XDG_RUNTIME_DIR/hypr/[HIS]/.socket2.sock` — Used for events. Hyprland will write to each
> connected client live events like this: `EVENT>>DATA\n`

Where `[HIS]` = `echo $HYPRLAND_INSTANCE_SIGNATURE`. Relevant events (verbatim from the events
table on that page):

| event | payload |
|---|---|
| `openwindow` | `WINDOWADDRESS, WORKSPACENAME, WINDOWCLASS, WINDOWTITLE` |
| `closewindow` | `WINDOWADDRESS` |
| `activewindow` | `WINDOWCLASS,WINDOWTITLE` |
| `activewindowv2` | `WINDOWADDRESS` |
| `movewindow` | `WINDOWADDRESS, WORKSPACENAME` |

Bash usage example from the wiki:

```sh
#!/bin/sh
handle() {
  case "$1" in
    focusedmon*) do_something_else ;;
    *) do_something ;;
  esac
}
socat -U - UNIX-CONNECT:$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock | \
  while read -r line; do handle "$line"; done
```

Use this only if you want a *live* registry (auto-remove state files whose foot window closed:
listen for `closewindow` and drop the matching entry). For v1 of the workflow you can skip it —
the state files can be pruned lazily by `focus-window.sh` when `hyprctl clients -j` no longer
contains their title. (Design choice — researcher inference built on verified primitives.)

---

## 3. foot: giving each agent terminal a stable identity

From [foot(1)](https://man.archlinux.org/man/foot.1) and [foot.ini(5)](https://man.archlinux.org/man/foot.ini.5)
(Arch man pages, packaged from upstream [codeberg.org/dnkl/foot](https://codeberg.org/dnkl/foot)):

> `-T, --title=TITLE` — Initial window title. Default: foot.
> `title` (foot.ini) — Initial window title. Default: foot.
> `-a, --app-id=ID` — Value to set the app-id property on the Wayland window to. Default:
> `foot` (normal mode), or `footclient` (server mode).

Key facts:

1. **foot never updates the title itself after startup.** From the official
   [foot wiki FAQ](https://codeberg.org/dnkl/foot/wiki/Home): *"That's expected, since foot
   only sets the initial window title (it never updates it after that), and the default window
   title is foot."* (That FAQ is about `foot -e cmd`, but the principle is the same.)
2. **Applications inside the terminal CAN update the title** — foot implements the standard
   OSC sequences. From [dnkl/foot README](https://codeberg.org/dnkl/foot) /
   [foot-ctlseqs(7)](https://man.archlinux.org/man/extra/foot/foot-ctlseqs.7.en):
   > `OSC 0` — change window icon + title (but only title is actually supported)
   > `OSC 2` — change window title
   (i.e. `printf '\e]2;%s\a' "my title"`). Also noteworthy: `OSC 9` — desktop notification
   (title+body only, **no actions** — so OSC 9 alone can't give click-to-focus).
3. **Server mode**: `foot -s` runs the server; windows are opened with `footclient`, which
   accepts the same `-T`/`-a` flags (default app-id becomes `footclient`). Verified only as
   the documented default above; footclient flag pass-through not separately quoted here.

### Recommended convention (per-instance title at launch)

Launch each agent with a fixed, unique initial title and **prevent the shell from overwriting
it**:

```bash
# e.g. a wrapper:  ai foot "claude" → runs `claude` in a foot titled "ai · claude · dotfiles"
foot -T "ai · claude · dotfiles"    # title is stable for the window's lifetime
```

- If your zsh/bash rc sets the title via OSC 2 (many do: `precmd` hooks), either disable that
  or re-emit an agent-tagged title. In zsh you can guard with an env var set by the wrapper:
  `[ -z "$AI_TERM" ] && print -Pn '\e]2;%n@%m: %~\a'`.
- Alternative identity: `-a` app-id. Hyprland's `class:` field is the Wayland app-id, so
  `foot -a ai-claude` gives a matchable class — but one class per *kind*, not per *instance*,
  and mixing per-instance app-ids gets messy with windowrules. **Title is the better key**
  (researcher recommendation; both primitives verified above).
- Matching is then trivial: `hyprctl clients -j | jq '.[] | select(.title | startswith("ai · "))'`
  gives every agent window with its address.

---

## 4. Waybar custom module (official wiki)

All from [Module: Custom — Waybar wiki](https://github.com/alexays/waybar/wiki/Module:-Custom)
and [Module: Custom: Menu](https://github.com/alexays/waybar/wiki/Module:-Custom:-Menu).

### Widget: signal-driven, JSON return type

Key options (quoted/condensed from the wiki table):

> `exec` — The path to the script, which should be executed.
> `return-type` — `json`: `{"text": "$text", "alt": "$alt", "tooltip": "$tooltip", "class": "$class", "percentage": $percentage}` … The whole JSON object must be printed on a single line.
> `signal` — integer — The signal number used to update the module … **If no interval is defined then a signal will be the only way to update the module.**
> `interval` — … Use `once` if you want to execute the module only on startup. You can update it manually with a signal.
> `on-click` / `on-click-right` / `on-click-middle` — Command to execute when clicked…
> `exec-on-event` — bool, default true — If an event command is set … then re-execute the script after executing the event command.
> `menu` / `menu-file` / `menu-actions` — see below.

Signal mechanism, from the wiki's own example:

> Under the premise that interval is not defined, you can use the signal and update … with **`pkill -RTMIN+8 waybar`**.

Styling: `#custom-<name>` and `#custom-<name>.<class>` (class set by the script's JSON).

Config (`~/.config/waybar/config.jsonc`):

```jsonc
"custom/agents": {
  "exec": "~/.config/waybar/scripts/agents-widget.sh",
  "return-type": "json",
  "interval": "once",          // run once; after that only signals update it
  "signal": 8,                 // pkill -RTMIN+8 waybar
  "format": "{icon} {text}",
  "format-icons": { "waiting": "󰀦", "clear": "󰁯" },
  "on-click": "agents-pick",   // or use menu (below)
  "tooltip": true
}
```

`agents-widget.sh` (reads the state dir from §1):

```bash
#!/bin/bash
dir="${XDG_RUNTIME_DIR:-/tmp}/agents"
n=$(find "$dir" -name '*.json' -newer /dev/null 2>/dev/null | wc -l)
if (( n > 0 )); then
  tooltip=$(jq -r '"\(.agent) · \(.project) — \(.event)"' "$dir"/*.json | paste -sd'\n' -)
  printf '{"text":"%d","alt":"waiting","class":"waiting","tooltip":"%s"}\n' "$n" "$tooltip"
else
  printf '{"text":"","alt":"clear","class":"clear","tooltip":"no agents waiting"}\n'
fi
```

(The tooltip field supports `\r`-separated multiline per the wiki: "To have multiline tooltips,
use `\r` in your script to separate the lines.")

### Click → list of agents → focus

**Option A — native waybar menu.** From
[Module: Custom: Menu](https://github.com/alexays/waybar/wiki/Module:-Custom:-Menu):

> A module that implements a `menu` needs 3 properties defined in its config:
> - `menu` — Action that popups the menu. i.e: `on-click`
> - `menu-file` — Location of the menu descriptor file. There need to be an element of type **GtkMenu with id menu**.
> - `menu-actions` — array — The actions corresponding to the buttons of the menu. The identifiers of each actions needs to exist as an id in the 'menu-file'…

`menu-file` is a **static GtkBuilder XML** (Gtk3 `GtkMenu`), items linked by id:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<interface>
  <object class="GtkMenu" id="menu">
    <child><object class="GtkMenuItem" id="claude_dotfiles"><property name="label">claude · dotfiles (needs input)</property></object></child>
    <child><object class="GtkMenuItem" id="pi_notes"><property name="label">pi · notes (done)</property></object></child>
  </object>
</interface>
```

```jsonc
"menu": "on-click",
"menu-file": "~/.config/waybar/agents_menu.xml",
"menu-actions": ["focus-window 'ai · claude · dotfiles'", "focus-window 'ai · pi · notes'"]
```

**Limitation (researcher inference from the wiki): the menu XML is a static file read at popup
time; waybar has no documented way to generate menu items dynamically from the exec script.**
Workaround: regenerate both the XML and the config's `menu-actions` from the state dir before
sending the signal (waybar reloads config on change — but a config rewrite on every agent event
is heavy). Practical compromise: cap the menu at a fixed number of slots.

**Option B (recommended) — external picker.** `on-click` runs a script that lists the state
dir and pipes it into a picker. **Decision: we will use `dmenu`** (not wofi/rofi):

```bash
#!/bin/bash
# agents-pick
dir="${XDG_RUNTIME_DIR:-/tmp}/agents"
sel=$(jq -r '"\(.title) (\(.event))"' "$dir"/*.json \
  | dmenu -i -p "focus agent")
[ -n "$sel" ] || exit 0
exec focus-window "${sel%% (*}"   # strip " (event)" suffix → bare title
```

(dmenu prints the **displayed line** to stdout — no NUL-separated data pairs. Since the line
is `agent · project — event`, `focus-window.sh` already matches it as a title substring only
if the line *is* the title. Simplest fix: make the list lines **the window titles themselves**
(`ai · claude · dotfiles (needs input)`), so the picked line goes straight to
`focus-window "${sel%% (*}"` — strip the parenthesized status suffix. Alternatively prepend
the title and cut on a delimiter, e.g. `title :: status` → `cut -d' ' -f1`.)

Note: stock dmenu is an X11 program — it works under Xwayland on Hyprland (Xwayland enabled
by default). A pure-Wayland build exists as `dmenu-wayland` (binary also called `dmenu`) if
Xwayland is undesired. Pick whichever is installed; the script is identical either way. Option B gives a dynamic, unbounded list with zero config rewrites.

### `focus-window.sh` (the shared click handler)

```bash
#!/bin/bash
# focus-window <title-substring>: resolve current address, then focus
addr=$(hyprctl clients -j | jq -r --arg t "$1" '.[] | select(.title | test($t)) | .address' | head -n1)
[ -n "$addr" ] && hyprctl dispatch focuswindow "address:$addr"
# optional: also switch to its workspace if it's on another one —
# focuswindow already switches workspaces per its "focuses the first window matching" semantics (wiki).
```

---

## 5. Notification with click-to-focus (dunst)

Dunst fully supports actions. From [dunst documentation](https://dunst-project.org/documentation/)
and [dunstify(1)](https://man.archlinux.org/man/dunstify.1.en):

> Dunst allows notifiers (i.e.: programs that send the notifications) to specify actions. Dunst
> has support for both displaying and invoking them. ([dunst docs](https://dunst-project.org/documentation/))

`dunstify(1)` (compatible superset of notify-send):

> `-A, --action=ACTION` — Specifies the actions to display to the user.
> ArchWiki example: `dunstify --action="replyAction,reply" "Message received"`

**Critical config step** — from [dunst(5)](https://man.archlinux.org/man/extra/dunst/dunst.5.en)
(mouse settings live in the global section):

> `mouse_[left/middle/right]_click` (values: `none/do_action/close_current/close_all/context/context_all`) …
> Defaults: `mouse_left_click=close_current` …
> `do_action` — Invoke the action determined by the `action_name` rule. If there is no such
> action, open the context menu.

**The default left-click just closes the notification.** To make click = focus, set in
`~/.config/dunst/dunstrc`:

```ini
[global]
mouse_left_click = do_action
```

(Left-click then invokes the notification's `default`/`action_name` action — the dunst docs
guide ["Using notification actions"](https://dunst-project.org/documentation/guides/) shows
`dunstify --action` wiring end-to-end; also note from the same guide: *"After a notification is
closed, however, the action is also invalidated"* — the action only works while the
notification is on screen, which is exactly what we want for focus-on-click.)

### The notification command (called from agent hooks)

```bash
dunstify --action="focus,focus window" \
         --app-name="ai-agents" --urgency=critical \
         "claude · dotfiles needs input" "permission_prompt — click to focus" \
         --replace=$NOTIF_ID \
         --action-handler…
```

⚠️ Correction — dunstify has no `--action-handler` flag. **dunst cannot run an arbitrary
command directly from an action key**; the action's *name* is sent back by the daemon when you
click. The standard pattern (per the dunst docs guide) is that the *sender* handles the return
value. dunstify prints the invoked action's name on stdout and exits — but dunstify exits
immediately after sending unless it waits. The practical wiring used by community projects
(see §8, e.g. agent-notifier) is: the helper script that sends the notification keeps running
attached (or `dunstify` blocks until the notification is acted on/closed — **this blocking
behavior is how dunstify reports actions; exact blocking semantics not separately quoted in
this run, verify with `man dunstify` locally**), then runs `focus-window.sh "$title"` when the
action name comes back:

```bash
#!/bin/bash
# notify-focus <title> <headline> <body>
action=$(dunstify --action="default,focus" "$2" "$3" -a ai-agents -u critical)
[ "$action" = "default" ] && focus-window "$1"
```

Simplest robust fallback if you don't want a blocking script per notification: make the whole
notification a **transient banner + rely on the waybar widget/menu for clicking**, and set
`mouse_left_click = do_action` with `action_name`/context as backup. mako note: mako also
supports notification actions (buttons + `makoctl invoke`), but since dunst is already in the
dotfiles and fully documented above, **stay with dunst** — no reason to switch. (mako's action
support was *not* verified from mako's own docs in this run.)

---

## 6. Agent-side hooks (the critical part)

### 6.1 Claude Code — official hooks

From [Hooks reference](https://code.claude.com/docs/en/hooks) and
[hooks guide](https://code.claude.com/docs/en/hooks-guide):

Hook events (verbatim subset of the lifecycle table): `SessionStart`, `UserPromptSubmit`,
`PreToolUse`, `PermissionRequest` ("When a tool call needs a permission decision"),
`Notification` ("When Claude Code sends a notification"), `Stop` ("When Claude finishes
responding"), `SessionEnd`, `SubagentStart`/`SubagentStop`, plus newer ones
(`PermissionDenied`, `PostToolBatch`, `StopFailure`, `TaskCompleted`, `TeammateIdle`, …).

Common stdin JSON fields (verbatim table from the reference):

| field | description |
|---|---|
| `session_id` | Current session identifier |
| `transcript_path` | Path to conversation JSON |
| `cwd` | Current working directory when the hook is invoked |
| `permission_mode` | `"default"`, `"plan"`, `"acceptEdits"`, `"auto"`, `"dontAsk"`, or `"bypassPermissions"` |
| `hook_event_name` | Name of the event that fired |

Notification hook specifics (from the reference + guide):

> In addition to the common input fields, Notification hooks receive `message` with the
> notification text, an optional `title`, and `notification_type` indicating which type fired.
> Notification hooks can't block or modify notifications.

Notification **matcher values** (from the guide's matcher table, verbatim):
`permission_prompt`, `idle_prompt`, `auth_success`, `elicitation_*`, `agent_needs_input`,
`agent_completed`, `quota_auto_resume_*` — e.g. *"`permission_prompt` — Claude needs you to
approve a tool use … and the prompt has waited about six seconds"*, *"`idle_prompt` — Claude
finished responding about 60 seconds ago and you haven't typed since"*.
(`agent_needs_input`/`agent_completed` require ≥ v2.1.198.)

Stop hooks receive `stop_hook_active` (bool) — check it to avoid infinite continuation loops
(guide: Claude overrides a Stop hook that blocks eight times in a row).

**There is no `terminal_id` / window field in the hook input** (verified: full-text search of
the reference for `terminal_id` returns nothing). Window correlation must go through your own
registry keyed by `session_id` + `cwd` (§7).

Configuration (structure verified against the docs and a working third-party config): hooks
live under a `hooks` key in `~/.claude/settings.json` (user), `.claude/settings.json`
(project), or plugin `hooks/hooks.json`. Working example — the exact shape from
[agent-status](https://github.com/paulvandermeijs/agent-status/blob/master/crates/agent-status/README.md):

```json
{
  "hooks": {
    "Notification": [
      { "hooks": [ { "type": "command", "command": "agent-hook claude-code notify" } ] }
    ],
    "PermissionRequest": [
      { "hooks": [ { "type": "command", "command": "agent-hook claude-code notify" } ] }
    ],
    "Stop": [
      { "hooks": [ { "type": "command", "command": "agent-hook claude-code done" } ] }
    ],
    "UserPromptSubmit": [
      { "hooks": [ { "type": "command", "command": "agent-hook claude-code working" } ] }
    ],
    "SessionEnd": [
      { "hooks": [ { "type": "command", "command": "agent-hook claude-code clear" } ] }
    ]
  }
}
```

Each entry may also carry a `matcher` (empty/omitted = all) and per-hook `timeout`/`async`
(reference: *"Seconds before canceling … Defaults: 600 for command"*; async hooks run in the
background). The hook receives the JSON on **stdin**; parse with jq:

```bash
#!/bin/bash
# agent-hook <agent> <event> — reads Claude Code hook JSON on stdin
input=$(cat)
sid=$(jq -r .session_id <<<"$input")
cwd=$(jq -r .cwd <<<"$input")
msg=$(jq -r '.message // "finished"' <<<"$input")
title="ai · claude · $(basename "$cwd")"
agent-state set "$sid" agent=claude-code event="$2" title="$title" cwd="$cwd" message="$msg"
pkill -RTMIN+8 waybar
[ "$2" != "working" ] && notify-focus "$title" "claude · $(basename "$cwd")" "$msg"
```

Claude Code also has a **statusline** feature receiving session JSON (session_id, model,
workspace) — potentially a second source for a waybar widget; see
[code.claude.com/docs/en/statusline](https://code.claude.com/docs/en/statusline) (not needed if
hooks are wired; not deeply verified here).

### 6.2 opencode — plugins + event bus

From [opencode plugins docs](https://opencode.ai/docs/plugins/):

> A plugin is a JavaScript/TypeScript module that exports one or more plugin functions. Each
> function receives a context object and returns a hooks object.

Context: `{ project, client, $, directory, worktree }` — `$` is Bun's shell API for running
commands. Locations: `~/.config/opencode/plugins/` (global), `.opencode/plugins/` (project);
auto-loaded at startup; **no per-launch flag** (confirmed by agent-status's docs).

Relevant events (verbatim from the docs' event list): `session.idle`, `session.created`,
`session.deleted`, `permission.asked`, `permission.replied`, `session.updated`,
`message.updated`, `tool.execute.before/after`. The docs' own notification example:

```typescript
export const NotificationPlugin = async ({ project, client, $ }) => {
  return {
    event: async ({ event }) => {
      if (event.type === "session.idle") {
        await $`osascript -e 'display notification "Session completed!" with title "opencode"'`
      }
    },
  }
}
```

Adapted for this workflow (`~/.config/opencode/plugins/agent-hook.ts`):

```typescript
export const AgentHookPlugin = async ({ $, directory }) => {
  const dir = `${process.env.XDG_RUNTIME_DIR ?? "/tmp"}/agents`
  const project = directory.split("/").filter(Boolean).pop() ?? "opencode"
  const title = `ai · opencode · ${project}`
  const write = async (event: string, sid: string) =>
    await $`echo ${JSON.stringify({ agent: "opencode", event, title, cwd: directory })}
      > ${dir}/${sid}.json`
  return {
    event: async ({ event }: any) => {
      const sid = event.properties?.sessionID ?? event.properties?.session ?? "unknown"
      switch (event.type) {
        case "session.idle":     await write("done", sid); break
        case "permission.asked": await write("notify", sid); break
        case "session.deleted":  await write("clear", sid); break
      }
      await $`pkill -RTMIN+8 waybar || true`
    },
  }
}
```

⚠️ The exact payload shape of `event` (where the session id lives) is **not spelled out in the
docs page fetched** — the `properties.sessionID` access above is modeled on the SDK client
types and must be checked against a live event (log one first). Contradiction to record:
agent-status's README wires opencode via a `permission.updated` event, which **does not appear
in the official event list** (official: `permission.asked` / `permission.replied`) — likely an
older/newer opencode version difference. Verify against your installed opencode.

### 6.3 pi — extensions (no shell hooks)

Local primary sources: `/home/himon/.local/share/mise/installs/pi/0.87.1/docs/extensions.md`
(read in this run) and `…/docs/settings.md`.

pi has **no Claude-Code-style hooks in settings.json** (settings.md — read end-to-end above —
has model/tools/session/terminal/network/shell/resources sections only, no hooks or
notification settings). The mechanism is TypeScript extensions:

> An extension exports a default factory that receives `ExtensionAPI` … Extensions are
> TypeScript modules that add executable behavior to Pi. Use one when a workflow needs tools,
> commands, **event handlers**, … or terminal UI.

Load: drop into `~/.pi/agent/extensions/*.ts` (auto-loaded) or `pi --extension ./file.ts`
(docs/extensions.md: *"During development, load a file directly: `pi --extension ./hello.ts`"*).
Events via `pi.on()` — from extensions.md:

> A run proceeds from input and `before_agent_start`, through model, message, and tool events,
> to `agent_end`. … **`agent_settled` is final and notification-only; use it when an
> integration needs to know Pi will not continue automatically.**

`agent_settled` is exactly the "pi is done / waiting for you" signal. The full working event
map (from agent-status's pi bridge, which runs in production against pi):
`session_start`, `before_agent_start`, `tool_execution_start`, `tool_call`,
`tool_execution_end`, `agent_end`, `session_switch`, `session_branch`, `session_shutdown`.

Key honest limitation (agent-status README, verbatim):

> **pi has no shell hook for "agent paused for permission"** — but the bridge reconstructs it
> from two sources: the built-in `ask` tool (always `notify`…) and a prediction of pi's
> tool-approval dialog read from `~/.pi/agent/settings.json` (`tools.approvalMode`:
> `always-ask` / `write` / `yolo`…). In the default `yolo` mode only `ask` produces `notify`.

Extension for this workflow (`~/.pi/agent/extensions/agent-notify.ts`):

```typescript
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { $ } from "zx" // or child_process — see note

export default function (pi: ExtensionAPI) {
  const write = (ctx: any, event: string) => {
    const cwd = ctx.session?.cwd ?? process.cwd()
    const sid = ctx.session?.id ?? "pi"
    const title = `ai · pi · ${cwd.split("/").filter(Boolean).pop()}`
    const file = `${process.env.XDG_RUNTIME_DIR ?? "/tmp"}/agents/${sid}.json`
    $`echo ${JSON.stringify({ agent: "pi", event, title, cwd })} > ${file}`
    $`pkill -RTMIN+8 waybar || true`
    if (event !== "working") $`notify-focus ${title} "pi · done" "${event}"`
  }
  pi.on("session_start", (ctx) => write(ctx, "idle"))
  pi.on("before_agent_start", (ctx) => write(ctx, "working"))
  pi.on("agent_settled", (ctx) => write(ctx, "done"))
  pi.on("session_shutdown", (ctx) => /* remove state file */ {})
}
```

⚠️ Unverified details (check against the installed types at
`~/.local/share/mise/installs/pi/0.87.1/…/extensions/types.ts` — referenced by extensions.md as
the source of exact event/context types): the exact context object shape (`ctx.session.id`,
`ctx.session.cwd`), and how to run shell commands from an extension (Bun/`Bun.spawn` vs zx —
the pi docs don't show a shell helper; agent-status bakes the binary path into a generated
bridge file, implying plain child_process works). Treat the snippet as a sketch of the
verified *events*, not copy-paste code.

**pi-subagents** (`~/.pi/agent/npm/node_modules/pi-subagents`, README read in this run): it's
a delegation/fleet tool (child agents, FleetView TUI inspector, background runners, intercom,
`bg_wait`). It has **no desktop-notification or window-focus features** in its README/docs
index — nothing to reuse for this workflow beyond its own FleetView for seeing running work
inside the pi TUI.

---

## 7. State registry: mapping session → window

Requirements: map an agent event (keyed by `session_id` + `cwd`) to a Hyprland window.
Neither Claude Code (no terminal field in hook input — verified) nor opencode/pi events know
about windows. Therefore:

**Recommended: identify by window title, assigned at launch, resolved at click time.**

1. **Launch convention** — every agent runs in a foot window titled
   `ai · <agent> · <project-dir-basename>` (§3). A tiny wrapper makes this uniform:
   ```bash
   #!/bin/bash
   # ai <agent…>: claude | opencode | pi, run in a labeled foot
   agent="$1"; shift
   proj="$(basename "$PWD")"
   exec foot -T "ai · $agent · $proj" -e "$agent" "$@"
   ```
   (`foot -e cmd` runs cmd in the window — foot(1); verify flag interplay with `-T` locally.)
2. **State file** — `${XDG_RUNTIME_DIR}/agents/<session_id>.json`:
   ```json
   { "agent": "claude-code", "project": "dotfiles", "cwd": "/home/himon/Projects/dotfiles",
     "event": "notify", "title": "ai · claude · dotfiles", "ts": 1778163565,
     "message": "permission required" }
   ```
   Written by the Claude hooks / opencode plugin / pi extension (§6). Event vocabulary:
   `working | notify | done | idle | clear` (same vocabulary agent-status uses; `clear`
   deletes the file).
3. **Resolution at click time** — never store the Hyprland `address:` (it changes across
   restarts and window recreation); resolve title → address with `hyprctl clients -j | jq`
   at the moment of clicking (§2.2, §4). Title is stable for the window's lifetime (§3).
4. **Session-id bootstrap problem** (inference, flagged): Claude Code's `session_id` doesn't
   exist until the session starts, so the wrapper can't embed it in the title. That's fine —
   the registry keys the state file by session_id, but the *title* is derived from cwd, which
   the hook input provides (`cwd` field, verified). Two agents in the same directory will
   share a title — acceptable collision (focusing either is usually right); disambiguate by
   adding `$$` or a counter in the wrapper title if it matters.
5. **Stale-entry cleanup**: `clear` on SessionEnd/session_shutdown + lazy pruning (drop state
   files whose title no longer appears in `hyprctl clients -j`). Optionally a socket2
   `closewindow` listener (§2.4) for immediate cleanup.

---

## 8. Omarchy: what it actually ships (and what the YouTube video likely was)

The repo is [github.com/omacom/omarchy](https://github.com/omacom/omarchy) (redirects from
`basecamp/omarchy`; MIT; omarchy.org).

**Omarchy's built-in agent feature is a usage/limits panel, not a waiting monitor.** From the
official bar README ([`shell/plugins/bar/README.md`, `quattro` branch](https://github.com/basecamp/omarchy/blob/quattro/shell/plugins/bar/README.md)),
module catalogue, verbatim:

> `omarchy.agents` — AI coding agent limits with pace, today, last week, and all-time model
> breakdown — left = panel · right = launch agent · middle = next subscription

The current Omarchy bar is **Quickshell-based** (`omarchy-shell` plugin system, `shell.json`
config), not waybar — the same README states the bar is "the Quickshell implementation of the
Omarchy status bar … shipped as a first-party plugin of omarchy-shell". It also supports
custom `type: "command"` modules that **print plain text or Waybar-style JSON**
(`{"text":…,"tooltip":…,"class":…}`) with `interval`/`onClick` — so the §4 widget script is
portable to Omarchy wholesale (verified from the README's "Custom user modules" section).

Data source (from [`bin/omarchy-agent-usage-claude`](https://github.com/basecamp/omarchy/blob/fa955bfa/bin/omarchy-agent-usage-claude),
905-line Python script, docstring verbatim):

> Everything the agents panel shows for Claude comes from this one command: local transcript
> stats from `~/.claude/projects`, the stats-cache and history fallbacks …, **pi/omp and
> opencode sessions** that ran on an Anthropic provider, and the authoritative rate limits
> from Anthropic's OAuth usage endpoint.

The older default waybar config ([`config/waybar/config.jsonc`](https://github.com/basecamp/omarchy/blob/b50ec214/config/waybar/config.jsonc))
ships `custom/omarchy`, `hyprland/workspaces`, clock, update/voxtype/screenrecording/idle
indicators, tray, bluetooth, network, pulseaudio, cpu, battery — **no agent-waiting widget**.

So the "agents waiting for you, click to focus" thing on YouTube was almost certainly a
**community** project, not stock Omarchy. Community primary repos (brief, per task):

- [paulvandermeijs/agent-status](https://github.com/paulvandermeijs/agent-status) — Rust CLI,
  tmux `status-right` indicator of sessions waiting on input, supports **Claude Code, pi, omp,
  opencode**; one JSON file per session under `${XDG_RUNTIME_DIR}/agent-status/`; generates
  the hook/extension/plugin wiring for all four agents. The single best reference
  implementation for the hook layer of this design. (tmux-focused: focuses *panes*, not
  Hyprland windows.)
- [bengous/agent-notifier-omarchy](https://github.com/bengous/agent-notifier-omarchy) —
  "turns Codex, Claude Code, and Pi completion hooks into desktop alerts and into a bar widget
  that lists the sessions still waiting for you. **Each entry focuses its source window**" —
  closest to the exact user request (README claim; implementation not audited).
- [5d0tal1gat0r/omarchy-agent-watcher](https://github.com/5d0tal1gat0r/omarchy-agent-watcher) —
  one bar pill per agent session per Hyprland workspace, state working/waiting/done/idle,
  blinking, click focuses window (README claim; not audited).
- [rohaquinlop/omarchy-agent-collectors](https://github.com/rohaquinlop/omarchy-agent-collectors) —
  usage collectors (pi, opencode) writing into Omarchy's agents-panel contract.

---

## 9. Sources

Kept (primary, used above):

- Hyprland wiki — Dispatchers: https://wiki.hypr.land/Configuring/Basics/Dispatchers/
- Hyprland wiki — IPC: https://wiki.hypr.land/IPC/
- Hyprland wiki — Using hyprctl: https://wiki.hypr.land/Configuring/Advanced-and-Cool/Using-hyprctl/
- Hyprland wiki — Window Rules (current/0.54): https://wiki.hypr.land/Configuring/Basics/Window-Rules/ , https://wiki.hypr.land/0.54.0/Configuring/Window-Rules/
- Hyprland wiki — Window Rules 0.47 (classic windowrulev2): https://wiki.hyprland.org/0.47.0/Configuring/Window-Rules/
- Hyprland issue #4289 (dispatch title/class caveat): https://github.com/hyprwm/Hyprland/issues/4289
- Hyprland discussion #830 (address is always unique): https://github.com/hyprwm/Hyprland/discussions/830
- foot(1): https://man.archlinux.org/man/foot.1 · foot.ini(5): https://man.archlinux.org/man/foot.ini.5 · foot-ctlseqs(7): https://man.archlinux.org/man/extra/foot/foot-ctlseqs.7.en · foot repo/wiki: https://codeberg.org/dnkl/foot , https://codeberg.org/dnkl/foot/wiki/Home
- Waybar wiki — Module: Custom: https://github.com/alexays/waybar/wiki/Module:-Custom
- Waybar wiki — Module: Custom: Menu: https://github.com/alexays/waybar/wiki/Module:-Custom:-Menu
- dunst docs: https://dunst-project.org/documentation/ , actions guide: https://dunst-project.org/documentation/guides/ , dunst(5): https://man.archlinux.org/man/extra/dunst/dunst.5.en , dunstify(1): https://man.archlinux.org/man/dunstify.1.en
- Claude Code — Hooks reference: https://code.claude.com/docs/en/hooks · hooks guide: https://code.claude.com/docs/en/hooks-guide · statusline: https://code.claude.com/docs/en/statusline
- opencode — Plugins docs: https://opencode.ai/docs/plugins/
- pi (local): /home/himon/.local/share/mise/installs/pi/0.87.1/README.md , docs/index.md , docs/extensions.md , docs/settings.md ; pi-subagents: /home/himon/.pi/agent/npm/node_modules/pi-subagents/README.md
- Omarchy: https://github.com/omacom/omarchy · shell/plugins/bar/README.md (quattro): https://github.com/basecamp/omarchy/blob/quattro/shell/plugins/bar/README.md · bin/omarchy-agent-usage-claude: https://github.com/basecamp/omarchy/blob/fa955bfa/bin/omarchy-agent-usage-claude · config/waybar/config.jsonc: https://github.com/basecamp/omarchy/blob/b50ec214/config/waybar/config.jsonc
- agent-status (reference implementation): https://github.com/paulvandermeijs/agent-status
- agent-notifier-omarchy: https://github.com/bengous/agent-notifier-omarchy · omarchy-agent-watcher: https://github.com/5d0tal1gat0r/omarchy-agent-watcher

Rejected/deprioritized:

- DeepWiki/secondhand wiki mirrors (deepwiki.com) — aggregator, not primary.
- YouTube/Omarchy marketing pages — not primary; repo cited instead.
- Various SEO "waybar custom module tutorial" blog posts — redundant with the official wiki.
- `gotalab/claude-code-spec` (unofficial mirror of Claude docs) — superseded by code.claude.com.

## 10. Could NOT verify from primary sources (check locally before relying on)

1. **`foot -e` combined with `-T`** (title surviving when running a command) — foot(1)
   documents both flags; their interaction isn't quoted. Test: `foot -T "test" -e bash`.
2. **dunstify blocking-until-action semantics** (does `dunstify --action` block and print the
   chosen action on stdout?) — `man dunstify` locally; the dunst docs guide shows action
   round-trips but I did not capture the exact exit/stdout contract text.
3. **dmenu output format / availability**: decision made to use dmenu instead of wofi — it
   prints the selected *displayed line* to stdout (no data-channel), so list lines should be
   window titles (possibly with a status suffix to strip). Not verified from dmenu docs in
   this run; check `man dmenu` locally. Also confirm which dmenu variant is installed
   (`dmenu` X11/Xwayland vs `dmenu-wayland`) and its flags (`-i`, `-p`, `-l` for vertical).
4. **opencode event payload shape** (`event.properties.sessionID` etc.) and the
   `permission.updated` vs `permission.asked` discrepancy (agent-status uses
   `permission.updated`; official docs list `permission.asked`/`permission.replied`).
5. **pi extension context shape** (`ctx.session.id` / `ctx.session.cwd`) and the sanctioned
   way to spawn processes from a pi extension — read
   `~/.local/share/mise/installs/pi/0.87.1/…/core/extensions/types.ts` (the file extensions.md
   points to) or the agent-status bridge `crates/agent-status/extensions/pi.ts`.
6. **mako action support** (for the dunst-vs-mako comparison) — only dunst was verified.
7. Whether your installed Hyprland is ≥0.55 (Lua config) or ≤0.54 (hyprlang) — run
   `hyprctl version`; window-rule syntax differs (§2.3).
