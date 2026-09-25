// agents-notify: pi → agent-hook bridge (agents-notify spec, issue 04).
//
//   before_agent_start → working
//   agent_settled      → done   (not agent_end: retries/compaction/follow-ups)
//   session_shutdown   → clear
//   ask tool           → notify while the dialog is open, working after
//
// pi 0.87.1 has no built-in ask tool, so this extension registers one — the
// only moment pi asks for input (no permission mode in this version).
// Launch via `ai pi` (standalone foot) so agent-hook's PPID walk reaches the
// window's foot PID; the extension runs in-process, the chain stays intact.

import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";
import { Type } from "typebox";
import { spawnSync } from "node:child_process";

// spawnSync is load-bearing: async spawns race done vs clear and leave a
// ghost state file. ponytail: blocks the event loop ~15ms per event.
function hook(event: string, ctx: any, message = "") {
	spawnSync("agent-hook", ["pi", event], {
		input: JSON.stringify({ session_id: ctx.sessionManager.getSessionId(), cwd: ctx.cwd, message }),
	});
}

export default function (pi: ExtensionAPI) {
	pi.on("before_agent_start", async (_e, ctx) => hook("working", ctx));
	pi.on("agent_settled", async (_e, ctx) => hook("done", ctx));
	pi.on("session_shutdown", async (_e, ctx) => hook("clear", ctx));

	pi.registerTool({
		name: "ask",
		label: "Ask",
		description: "Ask the user a question and wait for their answer. Use when you need a decision or information only the user has.",
		parameters: Type.Object({ question: Type.String({ description: "The question to ask the user" }) }),
		executionMode: "sequential",
		async execute(_id, params, _signal, _onUpdate, ctx) {
			hook("notify", ctx, params.question);
			if (!ctx.hasUI) {
				return { content: [{ type: "text", text: "No UI available: put the question to the user in your reply instead of answering it yourself." }] };
			}
			const answer = await ctx.ui.input(params.question, "");
			hook("working", ctx);
			return { content: [{ type: "text", text: answer ? `User answered: ${answer}` : "User gave no answer" }] };
		},
	});
}
