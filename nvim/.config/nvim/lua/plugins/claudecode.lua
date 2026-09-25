require("claudecode").setup({
	terminal = {
		split_side = "right",
		split_width_percentage = 0.50,
		provider = "external",
		provider_opts = {
			external_terminal_cmd = "foot --working-directory %s -e %s",
			-- external_terminal_cmd = "alacritty msg create-window --working-directory %s -e %s",
			-- external_terminal_cmd = "alacritty --working-directory %s -e %s",
			-- external_terminal_cmd = "alacritty --working-directory %s -e %s",
			-- %s = claude command; cwd comes from nvim's cwd (jobstart), foot is
			-- standalone via `ai` so the agent-hook PPID chain reaches the window
			external_terminal_cmd = "ai %s",
		},
	},
	terminal_cmd = "/home/himon/.local/bin/claude --dangerously-skip-permissions",
})

vim.keymap.set("n", "<leader>ac", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude" })
vim.keymap.set("n", "<leader>ar", "<cmd>ClaudeCode --resume<cr>", { desc = "Resume Claude" })
vim.keymap.set("n", "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", { desc = "Add current buffer to Claude" })
vim.keymap.set("v", "<leader>as", "<cmd>ClaudeCodeSend<cr>", { desc = "Send to Claude" })
