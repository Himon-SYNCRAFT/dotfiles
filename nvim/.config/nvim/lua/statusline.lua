local function current_buffer_number()
    return "﬘ " .. vim.api.nvim_get_current_buf()
end

local function diff_source()
    local gitsigns = vim.b.gitsigns_status_dict
    if gitsigns then
        return {
            added = gitsigns.added,
            modified = gitsigns.changed,
            removed = gitsigns.removed
        }
    end
end

---@diagnostic disable-next-line: unused-function, unused-local
local function current_working_dir()
    local cwd = string.sub(vim.fn.getcwd(), 12)
    return "~" .. cwd
end

local function codium_status() return vim.fn['codeium#GetStatusString']() end
local CodeGPTModule = require("codegpt")

-- local custom_auto = require "lualine.themes.auto"
-- custom_auto.normal.a.bg = "#3a3a3a"
-- custom_auto.normal.a.fg = "#d1d1f7"
-- custom_auto.normal.b.bg = "#4e4e4e"
-- custom_auto.normal.b.fg = "#d1d1f7"
-- custom_auto.normal.c.bg = "#626262"
-- custom_auto.normal.c.fg = "#d1d1f7"
-- custom_auto.normal.x = custom_auto.normal.c
-- custom_auto.normal.y = custom_auto.normal.b
-- custom_auto.normal.z = custom_auto.normal.a

-- custom_auto.insert.a.bg = "#3a3a3a"
-- custom_auto.insert.a.fg = "#d1d1f7"
-- custom_auto.insert.b.bg = "#4e4e4e"
-- custom_auto.insert.b.fg = "#d1d1f7"
-- custom_auto.insert.c.bg = "#626262"
-- custom_auto.insert.c.fg = "#d1d1f7"
-- custom_auto.insert.x = custom_auto.insert.c
-- custom_auto.insert.y = custom_auto.insert.b
-- custom_auto.insert.z = custom_auto.insert.a

-- custom_auto.command.a.bg = "#3a3a3a"
-- custom_auto.command.a.fg = "#d1d1f7"
-- custom_auto.command.b.bg = "#4e4e4e"
-- custom_auto.command.b.fg = "#d1d1f7"
-- custom_auto.command.c.bg = "#626262"
-- custom_auto.command.c.fg = "#d1d1f7"
-- custom_auto.command.x = custom_auto.command.c
-- custom_auto.command.y = custom_auto.command.b
-- custom_auto.command.z = custom_auto.command.a

-- custom_auto.visual.a.bg = "#3a3a3a"
-- custom_auto.visual.a.fg = "#d1d1f7"
-- custom_auto.visual.b.bg = "#4e4e4e"
-- custom_auto.visual.b.fg = "#d1d1f7"
-- custom_auto.visual.c.bg = "#626262"
-- custom_auto.visual.c.fg = "#d1d1f7"
-- custom_auto.visual.x = custom_auto.visual.c
-- custom_auto.visual.y = custom_auto.visual.b
-- custom_auto.visual.z = custom_auto.visual.a
--
local theme = require "lualine.themes.catppuccin"

theme.normal.a.gui = "bold"
theme.command.a.gui = "bold"
theme.insert.a.gui = "bold"
theme.replace.a.gui = "bold"
theme.visual.a.gui = "bold"

local palette = require('catppuccin.palettes').get_palette "macchiato"

theme.normal.b.bg = palette['mantle']
theme.command.b.bg = palette['mantle']
theme.insert.b.bg = palette['mantle']
theme.replace.b.bg = palette['mantle']
theme.visual.b.bg = palette['mantle']

theme.normal.c.bg = palette['mantle']

theme.normal.b.fg = palette['text']
theme.command.b.fg = palette['text']
theme.insert.b.fg = palette['text']
theme.replace.b.fg = palette['text']
theme.visual.b.fg = palette['text']

-- theme.normal.c.fg = palette['text']

require("lualine").setup {
    options = {
        -- theme = 'everforest',
        theme = theme,
        -- theme = 'tokyonight',
        -- theme = 'kanagawa',
        icons_enabled = true,
        -- component_separators = {left = "", right = ""},
        -- component_separators = {left = " 󰧟 ", right = " 󰧟 "},
        component_separators = { left = "", right = "" },
        -- section_separators = {left = "", right = ""},
        section_separators = { left = "", right = "" },
        disabled_filetypes = {},
        always_divide_middle = false
    },
    sections = {
        lualine_a = { { "mode", padding = { left = 1, right = 1 } } },
        lualine_b = {
            {
                "diagnostics",
                sources = { "nvim_diagnostic", "coc" },
                always_visible = true,
                update_in_insert = false,
                sections = { "error", "warn", "info", "hint" },
                symbols = {
                    error = '󰅙 ',
                    warn = '󰀦 ',
                    info = '󰀨 ',
                    hint = '󰌵 '
                },
                padding = { right = 2, left = 3 }
            }
        },
        lualine_c = {
            {
                "filename",
                path = 1,
                symbols = { modified = " ", readonly = " 󰌾" },
                color = { fg = palette['mauve'] }
            },
            {
                "filetype",
                icon_only = true,
                colored = true,
                icon = { align = "left" }
            }, { codium_status }, { CodeGPTModule.get_status }
        },
        lualine_x = {
            {
                "b:gitsigns_head",
                icon = "",
                padding = { left = 2, right = 2 },
                color = { fg = palette['lavender'] }
            }, { "diff", source = diff_source, padding = { left = 2, right = 2 } }
        },
        lualine_y = {
            -- {current_working_dir},
            {
                "location",
                icon = { '', align = 'right' },
                padding = { left = 2, right = 3 },
                color = { fg = palette['teal'] }
            }
        },
        lualine_z = { { function() return '' end, padding = 0, draw_empty = true } }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {
            {
                "filename",
                path = 0,
                symbols = { modified = " ", readonly = " 󰌾" }
            }
        },
        lualine_x = { "location" },
        lualine_y = { { current_buffer_number } },
        lualine_z = {}
    },
    extensions = { 'trouble', 'quickfix' }
}
