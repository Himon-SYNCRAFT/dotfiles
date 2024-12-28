local map = vim.api.nvim_set_keymap
local mapopts = { noremap = true, silent = true }

map("n", ";", "A;<ESC>", mapopts)
