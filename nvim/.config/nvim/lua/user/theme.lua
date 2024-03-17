vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅙", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀦", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌵", numhl = "" })
vim.fn.sign_define("DiagnosticSignInformation", {
    texthl = "DiagnosticSignInformation",
    text = "󰀨",
    numhl = "",
})

-- Kanagawa
-- require("kanagawa").setup({
--     compile = false,  -- enable compiling the colorscheme
--     undercurl = true, -- enable undercurls
--     commentStyle = { italic = true },
--     functionStyle = { bold = true },
--     keywordStyle = { bold = true },
--     statementStyle = { bold = true },
--     typeStyle = { bold = true },
--     transparent = true,    -- do not set background color
--     dimInactive = false,   -- dim inactive window `:h hl-NormalNC`
--     terminalColors = true, -- define vim.g.terminal_color_{0,17}
--     theme = "wave",        -- Load "wave" theme when 'background' option is not set
--     background = {
--         -- map the value of 'background' option to a theme
--         dark = "wave", -- try "dragon" !
--         light = "lotus",
--     },
--     colors = {
--         theme = { all = { ui = { bg_gutter = "none" } } }
--     },
--     overrides = function(colors)
--         return {
--             StatusLine = { fg = colors.palette.fujiWhite, bg = colors.palette.waveAqua1, blend = 10, bold = true },
--             StatusLineNC = { fg = colors.palette.sumiInk0, bg = colors.palette.sumiInk6 },
--         }
--     end,
-- })
--
-- Catppuccin
vim.g.catppuccin_flavour = "latte" -- latte, frappe, macchiato, mocha

-- require("catppuccin").setup({
--     dim_inactive = { enabled = false, shade = "dark", percentage = 0.5 },
--     transparent_background = true,
--     -- transparent_background = false,
--     no_italic = true,
--     no_bold = false,
--     styles = {
--         functions = { "bold" },
--         keywords = { "bold" },
--         booleans = { "bold" },
--         types = { "bold" },
--         -- functions = {},
--         -- keywords = {},
--         -- booleans = {},
--         -- types = {},
--         variables = {},
--     },
--     custom_highlights = function(colors)
--         return {
--             ["@parameter.php"] = { style = {} },
--             -- ["@conditional.php"] = {style = {'bold'}}
--         }
--     end,
--     integrations = {
--         cmp = true,
--         treesitter = true,
--         gitsigns = true,
--         ts_rainbow = true,
--         telescope = { enabled = true },
--         noice = true,
--         notify = true,
--     },
-- })

-- Tokyonight
-- require('tokyonight').setup({
--     style = 'storm',
--     transparent = true,
--     terminal_colors = true,
--     dim_inactive = {enabled = false, shade = "dark", percentage = 0.5},
--     lualine_bold = true,
--     styles = {
--         keywords = {bold = true, italic = false},
--         functions = {bold = true, italic = false},
--         variables = {italic = true}
--     }
-- })

-- vim.cmd [[colorscheme tokyonight-storm]]
--
--
require("rose-pine").setup({
    variant = "auto",      -- auto, main, moon, or dawn
    dark_variant = "moon", -- main, moon, or dawn
    dim_inactive_windows = false,
    extend_background_behind_borders = true,

    enable = {
        terminal = true,
        legacy_highlights = true, -- Improve compatibility for previous versions of Neovim
        migrations = true,        -- Handle deprecated options automatically
    },

    styles = { bold = true, italic = false, transparency = true },

    groups = {
        border = "muted",
        link = "iris",
        panel = "surface",

        error = "love",
        hint = "iris",
        info = "foam",
        note = "pine",
        todo = "rose",
        warn = "gold",

        git_add = "foam",
        git_change = "rose",
        git_delete = "love",
        git_dirty = "rose",
        git_ignore = "muted",
        git_merge = "iris",
        git_rename = "pine",
        git_stage = "iris",
        git_text = "rose",
        git_untracked = "subtle",

        h1 = "iris",
        h2 = "foam",
        h3 = "rose",
        h4 = "gold",
        h5 = "pine",
        h6 = "foam",
    },

    highlight_groups = {
        -- Comment = { fg = "foam" },
        -- VertSplit = { fg = "muted", bg = "muted" },
        Function = { bold = true },
        Type = { bold = true },
        ["@type"] = { bold = true },
        ["@function.method.call"] = { bold = true },
        ["@function.method"] = { bold = true },
        Keyword = { bold = true },
        ["@keyword.conditional"] = { bold = true },
        ["@keyword.repeat"] = { bold = true },
        ["@keyword.operator"] = { bold = true, fg = "pine" },
        ["@punctuation.bracket"] = { fg = "pine" },
        Operator = { fg = "love" },
        Boolean = { bold = true },
        StatusLine = { fg = "love", bg = "love", blend = 10, bold = true },
        StatusLineNC = { fg = "subtle", bg = "surface" },
    },

    before_highlight = function(group, highlight, palette)
        -- Disable all undercurls
        -- if highlight.undercurl then
        --     highlight.undercurl = false
        -- end
        --
        -- Change palette colour
        -- if highlight.fg == palette.pine then
        --     highlight.fg = palette.foam
        -- end
    end,
})

vim.cmd("colorscheme rose-pine")
-- vim.cmd("colorscheme kanagawa")
-- vim.cmd("colorscheme catppuccin")
vim.opt.fillchars = "eob: ,vert: "

vim.cmd([[
	" autocmd Vimenter * hi Normal guibg=NONE ctermbg=NONE
    set termguicolors
    " set background=light
    set background=dark
    " set cursorline
    set noshowmode

    highlight ColorColumn ctermbg=12 guibg=#eb6f92 guifg=#2a273f
    call matchadd('ColorColumn', '\%82v', 100)

    augroup CursorLine
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
    augroup END
]])

-- local macchiato = require('catppuccin.palettes').get_palette "macchiato"

-- require("notify").setup({background_colour = macchiato['overlay2']})
-- require("notify").setup({ background_colour = "#393552" })
