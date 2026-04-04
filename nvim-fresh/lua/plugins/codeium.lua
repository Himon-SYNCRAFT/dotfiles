-- lua/plugins/codeium.lua
vim.keymap.set("i", "<C-o>", function()
    return vim.fn["codeium#Accept"]()
end, { expr = true })
