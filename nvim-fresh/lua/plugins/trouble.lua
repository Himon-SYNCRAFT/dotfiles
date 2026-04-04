-- lua/plugins/trouble.lua
require("trouble").setup({})

local mapopts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>da", "<cmd>Trouble diagnostics toggle<cr>", mapopts)
vim.keymap.set("n", "<leader>dg", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", mapopts)
vim.keymap.set("n", "<leader>de",
    "<cmd>Trouble diagnostics toggle filter = { buf = 0, severity = vim.diagnostic.severity.ERROR }<cr>",
    mapopts)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", mapopts)
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", mapopts)
vim.keymap.set("n", "<leader>dh", "[[<Cmd>lua vim.diagnostic.disable()<CR>]]", mapopts)
vim.keymap.set("n", "<leader>ds", "[[<Cmd>lua vim.diagnostic.enable()<CR>]]", mapopts)
