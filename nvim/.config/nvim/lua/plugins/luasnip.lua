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
			enable_autosnippets = false,
		})

		vim.keymap.set({ "i" }, "<C-K>", function()
			ls.expand()
		end, { silent = true })

		require("luasnip.loaders.from_snipmate").lazy_load()
		require("user.luasnip.php")
		require("user.luasnip.zig")
		require("user.luasnip.http")
		-- require("user.luasnip.go")
	end,
}
