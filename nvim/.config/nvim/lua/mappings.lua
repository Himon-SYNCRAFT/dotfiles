local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

vim.cmd [[
    cnoreabbrev W! w!
    cnoreabbrev Q! q!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wq wq
    cnoreabbrev Wa wa
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qall qall
]]


map("n", "<leader>dg", "<cmd>Trouble<cr>", {noremap = true, silent = true})
