-- lua/plugins/luasnip.lua
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
