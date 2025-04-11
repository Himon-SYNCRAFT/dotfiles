local ls = require("luasnip")

ls.config.setup({
	enable_autosnippets = true,
})

vim.keymap.set({ "i" }, "<C-K>", function()
	ls.expand()
end, { silent = true })

require("user.luasnip.php")
require("user.luasnip.zig")
