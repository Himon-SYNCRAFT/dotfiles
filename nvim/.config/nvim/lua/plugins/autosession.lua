-- lua/plugins/autosession.lua
require("auto-session").setup({
	log_level = "error",
	auto_session_suppress_dirs = {
		"~/",
		"~/Projects",
		"~/Downloads",
		"~/.config",
		"/",
	},
	session_lens = {
		theme_conf = { border = true },
		theme = "dropdown",
		previewer = false,
	},
})

vim.keymap.set("n", "<leader>p", function()
	require("auto-session.pickers").open_session_picker()
end, { noremap = true, silent = true, desc = "Wybór sesji" })

vim.api.nvim_create_user_command("Restart", function()
	local ok, auto_session = pcall(require, "auto-session")

	if ok then
		auto_session.SaveSession()
	end

	vim.cmd("restart")
end, {})
