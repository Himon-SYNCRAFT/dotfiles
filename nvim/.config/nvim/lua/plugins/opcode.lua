local opencode = require("opcode")

opencode.setup({
	hostname = "127.0.0.1",
	port = 14096,
	command = "alacritty -e opencode --port {port}",
})

vim.keymap.set("n", "<leader>ao", function()
	opencode.connect()
end, { desc = "Open opencode in terminal" })

vim.keymap.set("n", "<leader>aos", function()
	opencode.list_sessions()
end, { desc = "Open opencode in terminal" })

vim.keymap.set("v", "<leader>os", function()
	opencode.send_selection()
end, { desc = "Add range to opencode" })

vim.keymap.set("n", "<leader>os", function()
	opencode.send_line()
end, { desc = "Add line to opencode" })

vim.keymap.set("n", "<leader>ob", function()
	opencode.send_file()
end, { desc = "Add buffer to opencode" })
