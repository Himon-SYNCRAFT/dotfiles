local opencode = require("opencode")

-- vim.keymap.set("n", "<leader>ao", function()
-- 	opencode.toggle()
-- end, { desc = "Toggle OpenCode" })

local function open_opencode()
	-- vim.fn.jobstart({ "alacritty", "-e", "opencode", "--port" }, {
	vim.fn.jobstart({ "footclient", "-e", "opencode", "--port" }, {
		detach = true,
	})
end

vim.keymap.set("n", "<leader>ao", open_opencode, { desc = "Open opencode in terminal" })

vim.keymap.set("v", "<leader>os", function()
	return require("opencode").operator("@this ", { append = true })
end, { desc = "Add range to opencode", expr = true })

vim.keymap.set("n", "<leader>os", function()
	return require("opencode").operator("@this ", { append = true })
end, { desc = "Add line to opencode", expr = true })

vim.keymap.set("n", "<leader>ob", function()
	return require("opencode").operator("@buffer", { append = true })
end, { desc = "Add buffer to opencode", expr = true })
