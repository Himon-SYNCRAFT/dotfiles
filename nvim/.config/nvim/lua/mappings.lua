-- lua/mappings.lua
-- Wyłącznie bindingi niezwiązane z pluginami.
-- Bindingi pluginów są w ich własnych plikach lua/plugins/*.lua

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
vim.keymap.set("n", "<C-j>", "<C-w>j", { silent = true, desc = "Przejdź do splitu poniżej" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { silent = true, desc = "Przejdź do splitu powyżej" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { silent = true, desc = "Przejdź do splitu po prawej" })
vim.keymap.set("n", "<C-h>", "<C-w>h", { silent = true, desc = "Przejdź do splitu po lewej" })

-- Terminal mode
vim.keymap.set("t", "<esc><esc>", "<C-\\><C-n>",          { silent = true, desc = "Wyjdź z trybu terminala" })
vim.keymap.set("t", "<C-j>",     "<C-\\><C-n><C-w>j",     { silent = true, desc = "Terminal: przejdź do splitu poniżej" })
vim.keymap.set("t", "<C-k>",     "<C-\\><C-n><C-w>k",     { silent = true, desc = "Terminal: przejdź do splitu powyżej" })
vim.keymap.set("t", "<C-l>",     "<C-\\><C-n><C-w>l",     { silent = true, desc = "Terminal: przejdź do splitu po prawej" })
vim.keymap.set("t", "<C-h>",     "<C-\\><C-n><C-w>h",     { silent = true, desc = "Terminal: przejdź do splitu po lewej" })

-- Tworzenie splitów
vim.keymap.set("n", "<leader>h", "<Cmd>split<CR>",  { silent = true, desc = "Otwórz poziomy split" })
vim.keymap.set("n", "<leader>v", "<Cmd>vsplit<CR>", { silent = true, desc = "Otwórz pionowy split" })

-- Wcięcia w visual mode (zachowują zaznaczenie)
vim.keymap.set("v", "<", "<gv", { silent = true, desc = "Zmniejsz wcięcie (zachowaj zaznaczenie)" })
vim.keymap.set("v", ">", ">gv", { silent = true, desc = "Zwiększ wcięcie (zachowaj zaznaczenie)" })

-- Czyszczenie highlight wyszukiwania
vim.keymap.set("n", "<Esc>", "<Cmd>nohlsearch<CR>", { silent = true, desc = "Wyczyść podświetlenie wyszukiwania" })

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

vim.keymap.set("n", "<leader>s", open_terminal, { silent = true, desc = "Otwórz terminal w małym splicie" })
