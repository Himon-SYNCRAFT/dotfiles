return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	dependencies = {
		"saadparwaiz1/cmp_luasnip",
	},
	config = function()
		local ls = require("luasnip")

		ls.config.setup({
			enable_autosnippets = true,
		})

		vim.keymap.set({ "i" }, "<C-K>", function()
			ls.expand()
		end, { silent = true })

		require("user.luasnip.php")
		require("user.luasnip.zig")
	end,
}
