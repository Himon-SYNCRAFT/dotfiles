return {
	"L3MON4D3/LuaSnip",
	version = "v2.*",
	build = "make install_jsregexp",
	-- dependencies = {
	-- 	"saadparwaiz1/cmp_luasnip",
	-- },
	config = function()
		require("user.luasnip.php")
		require("user.luasnip.zig")
	end,
}
