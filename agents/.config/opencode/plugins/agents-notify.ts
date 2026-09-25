// agents-notify: opencode → agent-hook bridge (agents-notify spec, issue 05).
//
// Event payloads and names verified live against opencode 2.0.15 — the v2
// runtime has no session.idle / session.status / permission.updated (those
// are the v1 SDK vocabulary the issue was researched from). Real mapping:
//   session.inbox.enqueued (user) / permission.replied / session.execution.started → working
//   permission.asked       → notify   (agent waits for a permission decision)
//   session.execution.succeeded / failed → done
//   session.deleted        → clear
// Events carry { type, data: { sessionID, ... } }; a plain { id, setup }
// default export is accepted, so no @opencode/plugin dependency is needed.
//
// Instances are per-location (ctx.location.directory = project dir). The
// plugin runs in the opencode server process: launch via `ai opencode`
// (standalone foot + standalone server) so the PPID walk in agent-hook
// reaches this window's foot PID — the shared background service detaches
// from the window and breaks the PID→window correlation.

export default {
  id: "agents-notify",
  setup(ctx: any) {
    const started = Date.now()
    const controller = new AbortController()
    void (async () => {
      try {
        for await (const event of ctx.event.subscribe({ signal: controller.signal })) {
          if (event.created < started) continue // replayed backlog (shared service)
          const d = event.data ?? {}
          const sid = d.sessionID
          if (!sid) continue
          const cwd = ctx.location.directory
          switch (event.type) {
            case "session.inbox.enqueued":
              if (d.item?.type === "user") hook("working", sid, cwd)
              break
            case "permission.replied":
            case "session.execution.started":
              hook("working", sid, cwd)
              break
            case "permission.asked":
              hook("notify", sid, cwd, `${d.action}: ${d.resources?.join(" ") ?? ""}`)
              break
            case "session.execution.succeeded":
              hook("done", sid, cwd)
              break
            case "session.execution.failed":
              hook("done", sid, cwd, "execution failed")
              break
            case "session.deleted":
              hook("clear", sid, cwd)
              break
          }
        }
      } catch { /* stream aborted on unload */ }
    })()
    return () => controller.abort()
  },
}

// spawnSync is load-bearing: it serializes per-session event order (a
// later done must not overtake this clear, same lesson as the pi adapter).
function hook(event: string, sid: string, cwd: string, message = "") {
  require("node:child_process").spawnSync("agent-hook", ["opencode", event], {
    input: JSON.stringify({ session_id: sid, cwd, message }),
  })
}
