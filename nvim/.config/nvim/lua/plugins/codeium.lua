-- lua/plugins/codeium.lua

local codeium = require("neocodeium")

codeium.setup()

vim.keymap.set("i", "<C-o>", codeium.accept)
