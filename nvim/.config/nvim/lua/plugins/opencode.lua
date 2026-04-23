local opencode = require("opencode")

vim.keymap.set("n", "<leader>ao", function()
	opencode.toggle()
end, { desc = "Toggle OpenCode" })

vim.keymap.set("v", "<leader>aos", function()
	return require("opencode").operator("@this ")
end, { desc = "Add range to opencode", expr = true })

vim.keymap.set("n", "<leader>aob", function()
	return require("opencode").operator("@buffer ")
end, { desc = "Add range to opencode", expr = true })
