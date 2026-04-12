-- lua/plugins/telescope.lua
local actions = require("telescope.actions")

require("telescope").setup({
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        file_browser = { hidden = true },
    },
    defaults = {
        preview = { timeout = 500, msg_bg_fillchar = "" },
        multi_icon = " ",
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
        },
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        sorting_strategy = "ascending",
        color_devicons = true,
        layout_config = {
            prompt_position = "bottom",
            horizontal = { width_padding = 0.04, height_padding = 0.1, preview_width = 0.6 },
            vertical = { width_padding = 0.05, height_padding = 1, preview_height = 0.5 },
        },
        mappings = {
            n = {
                ["<Del>"] = actions.close,
                ["<C-A>"] = function(pb)
                    require("user.telescope").multi_selection_open(pb)
                end,
            },
            i = {
                ["<esc>"] = actions.close,
                ["<C-A>"] = function(pb)
                    require("user.telescope").multi_selection_open(pb)
                end,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
        dynamic_preview_title = true,
    },
    pickers = {
        find_files = { follow = true },
    },
})

-- Ładowanie rozszerzeń przez user/telescope
require("user.telescope")

local tb = require("telescope.builtin")
local ut = require("user.telescope")

-- LSP navigation
vim.keymap.set("n", "gd", function() tb.lsp_definitions() end,      { silent = true, desc = "LSP: przejdź do definicji" })
vim.keymap.set("n", "gi", function() tb.lsp_implementations() end,  { silent = true, desc = "LSP: przejdź do implementacji" })
vim.keymap.set("n", "gr", function() tb.lsp_references() end,       { silent = true, desc = "LSP: pokaż referencje" })

-- File finding
vim.keymap.set("n", "<leader>e", ut.project_files, { silent = true, desc = "Szukaj plików w projekcie (git/fd)" })
vim.keymap.set("n", "<leader>df", function()
    tb.find_files({ find_command = { "fd", vim.fn.expand("<cword>") } })
end, { silent = true, desc = "Szukaj pliku po słowie pod kursorem" })
vim.keymap.set("n", "<space>e", ut.find_configs, { silent = true, desc = "Szukaj w plikach konfiguracyjnych" })

-- Search
vim.keymap.set("n", "<leader>f", "<Cmd>Telescope live_grep<CR>", { silent = true, desc = "Przeszukaj pliki (live grep)" })
vim.keymap.set("n", "<leader>G", function()
    tb.grep_string({ word_match = "-w" })
end, { silent = true, desc = "Szukaj całego słowa pod kursorem (grep)" })
vim.keymap.set("n", "<C-f>", tb.current_buffer_fuzzy_find,  { silent = true, desc = "Szukaj w bieżącym buforze" })
vim.keymap.set("n", "<space>x", tb.diagnostics,             { silent = true, desc = "Pokaż diagnostykę LSP" })

-- Buffers & navigation
vim.keymap.set("n", "<leader>b", function()
    tb.buffers({
        prompt_title = "",
        results_title = "﬘",
        layout_strategy = "vertical",
        layout_config = { width = 0.40, height = 0.55 },
    })
end, { silent = true, desc = "Lista otwartych buforów" })
vim.keymap.set("n", "<leader>o", function()
    tb.oldfiles({ results_title = "Recent-ish Files" })
end, { silent = true, desc = "Ostatnio otwarte pliki" })

-- Meta
vim.keymap.set("n", "<leader>c", function()
    tb.commands({ results_title = "Commands Results" })
end, { silent = true, desc = "Lista komend Vima" })
vim.keymap.set("n", "<leader>k", function()
    tb.keymaps({ results_title = "Key Maps Results" })
end, { silent = true, desc = "Lista skrótów klawiszowych" })
vim.keymap.set("n", "<space>h", function()
    tb.help_tags({ results_title = "Help Results" })
end, { silent = true, desc = "Przeszukaj pomoc Vima" })

-- Repos
vim.keymap.set("n", "<leader>rl", ut.repo_list, { silent = true, desc = "Lista repozytoriów git" })
