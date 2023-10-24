-- Kanagawa
-- require('kanagawa').setup({
--     compile = false, -- enable compiling the colorscheme
--     undercurl = true, -- enable undercurls
--     commentStyle = {italic = true},
--     functionStyle = {bold = true},
--     keywordStyle = {bold = true},
--     statementStyle = {bold = true},
--     typeStyle = {bold = true},
--     transparent = true, -- do not set background color
--     dimInactive = false, -- dim inactive window `:h hl-NormalNC`
--     terminalColors = true, -- define vim.g.terminal_color_{0,17}
--     theme = "wave", -- Load "wave" theme when 'background' option is not set
--     background = {
--         -- map the value of 'background' option to a theme
--         dark = "wave", -- try "dragon" !
--         light = "lotus"
--     },
--     colors = {theme = {all = {ui = {bg_gutter = "none"}}}}
-- })
-- vim.cmd("colorscheme kanagawa")
--
-- Catppuccin
vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

require("catppuccin").setup({
    dim_inactive = {enabled = false, shade = "dark", percentage = 0.5},
    transparent_background = true,
    -- transparent_background = false,
    no_italic = true,
    no_bold = false,
    styles = {
        functions = {"bold"},
        keywords = {"bold"},
        booleans = {"bold"},
        types = {"bold"},
        -- functions = {},
        -- keywords = {},
        -- booleans = {},
        -- types = {},
        variables = {}
    },
    custom_highlights = function(colors)
        return {
            ["@parameter.php"] = {style = {}}
            -- ["@conditional.php"] = {style = {'bold'}}
        }
    end,
    integrations = {
        cmp = true,
        treesitter = true,
        gitsigns = true,
        ts_rainbow = true,
        telescope = {enabled = true},
        noice = true,
        notify = true
    }
})
vim.cmd [[colorscheme catppuccin]]
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

vim.cmd [[
	autocmd Vimenter * hi Normal guibg=NONE ctermbg=NONE
    set background=dark
    set fcs=eob:\
]]

local macchiato = require('catppuccin.palettes').get_palette "macchiato"

require("notify").setup({background_colour = macchiato['overlay2']})
