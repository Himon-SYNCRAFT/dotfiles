-- lua/mappings.lua
-- Wyłącznie bindingi niezwiązane z pluginami.
-- Bindingi pluginów są w ich własnych plikach lua/plugins/*.lua

local map = vim.api.nvim_set_keymap
local mapopts = { noremap = true, silent = true }

-- Command abbreviations
vim.cmd([[
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
]])

-- Nawigacja splitów
map("n", "<C-j>", "<C-w>j", mapopts)
map("n", "<C-k>", "<C-w>k", mapopts)
map("n", "<C-l>", "<C-w>l", mapopts)
map("n", "<C-h>", "<C-w>h", mapopts)

-- Terminal mode
map("t", "<esc><esc>", "<C-\\><C-n>", mapopts)
map("t", "<C-j>", "<C-\\><C-n><C-w>j", mapopts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", mapopts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", mapopts)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", mapopts)

-- Tworzenie splitów
map("n", "<leader>h", ":<C-u>split<CR>", mapopts)
map("n", "<leader>v", ":<C-u>vsplit<CR>", mapopts)

-- Wcięcia w visual mode
map("v", "<", "<gv", mapopts)
map("v", ">", ">gv", mapopts)

-- Czyszczenie highlight
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", mapopts)

-- Terminal: otwórz w małym splicie z cd do katalogu projektu
local function vimdir()
    local workspace_folders = vim.lsp.buf.list_workspace_folders()
    if workspace_folders and #workspace_folders > 0 then
        return workspace_folders[1]
    end
    return vim.fn.expand("%:p:h")
end

local function open_terminal()
    vim.cmd(string.format("let $VIM_DIR = '%s'", vimdir()))
    vim.cmd("10split")
    vim.cmd("terminal fish")
    vim.api.nvim_input("Acd $VIM_DIR<cr>clear<cr>")
    vim.cmd("se winfixheight")
end

vim.keymap.set("n", "<leader>s", open_terminal, mapopts)
