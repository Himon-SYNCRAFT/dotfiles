-- lua/plugins/blink.lua
local luasnip = require("luasnip")

local kind_icons = {
    Text = "", Method = "", Function = "󰊕", Constructor = "",
    Field = "󰭷", Variable = "󰫧", Class = "󰠱", Interface = "",
    Module = "", Property = "󰓹", Unit = "", Value = "󰎠",
    Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
    File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
    Constant = "󰏿", Struct = "", Event = "", Operator = "󱓉",
    TypeParameter = "",
}

require("blink.compat").setup()

require("blink.cmp").setup({

    snippets = { preset = "luasnip" },

    -- ========================
    -- Klawisze (insert mode)
    -- ========================
    keymap = {
        preset = "none",
        -- Down/Up = Select behavior (podświetla, nie wstawia tekstu)
        ["<Down>"]    = { "select_next", "fallback" },
        ["<Up>"]      = { "select_prev", "fallback" },
        -- C-n/C-p = tylko gdy lista widoczna
        ["<C-n>"]     = {
            function(cmp)
                if cmp.is_visible() then return cmp.select_next() end
            end,
            "fallback",
        },
        ["<C-p>"]     = {
            function(cmp)
                if cmp.is_visible() then return cmp.select_prev() end
            end,
            "fallback",
        },
        -- Scroll dokumentacji
        ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
        ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
        -- Pokaż / zamknij
        ["<C-Space>"] = { "show", "fallback" },
        ["<C-e>"]     = { "cancel", "fallback" },
        -- CR: potwierdź tylko gdy coś jest zaznaczone (select = false)
        ["<CR>"]      = {
            function(cmp)
                if cmp.is_visible() and cmp.get_selected_item() ~= nil then
                    return cmp.accept({ behavior = "replace" })
                end
            end,
            "fallback",
        },
        -- Tab/S-Tab: tylko LuaSnip jumping
        ["<Tab>"]     = {
            function(_cmp)
                if luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                    return true
                end
            end,
            "fallback",
        },
        ["<S-Tab>"]   = {
            function(_cmp)
                if luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                    return true
                end
            end,
            "fallback",
        },
    },

    -- ========================
    -- Wygląd
    -- ========================
    appearance = {
        nerd_font_variant = "mono",
        kind_icons = kind_icons,
    },

    -- ========================
    -- Źródła
    -- ========================
    sources = {
        default = { "lazydev", "lsp", "snippets", "path", "dadbod", "buffer" },
        per_filetype = {
            sql   = { "dadbod" },
            mysql = { "dadbod" },
            plsql = { "dadbod" },
        },
        providers = {
            lazydev = {
                name         = "LazyDev",
                module       = "lazydev.integrations.blink",
                score_offset = 100,
            },
            buffer = {
                min_keyword_length = 5,
            },
            dadbod = {
                name   = "dadbod",
                module = "blink.compat.source",
                opts   = { cmp_name = "vim-dadbod-completion" },
            },
        },
    },

    -- ========================
    -- Completion menu
    -- ========================
    completion = {
        menu = {
            border = "rounded",
            winhighlight = "Normal:Normal,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            draw = {
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                },
                components = {
                    kind_icon = {
                        text = function(ctx)
                            return ctx.kind_icon .. ctx.icon_gap
                        end,
                        highlight = function(ctx)
                            return { { group = ctx.kind_hl, priority = 20000 } }
                        end,
                    },
                },
            },
        },
        documentation = {
            auto_show = true,
            window    = {
                border = "rounded",
                winhighlight = "Normal:Normal,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            },
        },
        -- Preselektuje pierwszy element (jak nvim-cmp domyślnie); nie wstawia tekstu do bufora aż do potwierdzenia
        list = {
            selection = { preselect = true, auto_insert = false },
        },
    },

    -- ========================
    -- Cmdline
    -- ========================
    cmdline = {
        enabled = true,
        keymap  = {
            preset  = "none",
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-e>"] = { "cancel", "fallback" },
            -- CR: nie akceptuje gdy nic nie zaznaczone
            ["<CR>"]  = {
                function(cmp)
                    if cmp.is_visible() and cmp.get_selected_item() ~= nil then
                        return cmp.accept()
                    end
                end,
                "fallback",
            },
        },
        -- Źródła per typ cmdline
        sources = function()
            local type = vim.fn.getcmdtype()
            if type == "/" or type == "?" then
                return { "buffer" }
            elseif type == ":" or type == "@" then
                return { "path", "cmdline" }
            end
            return {}
        end,
        completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = false } },
        },
    },
})

vim.g.vim_dadbod_completion_mark = "󰆼"

local function blink_hl_transparent()
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "NONE" })
    vim.api.nvim_set_hl(0, "BlinkCmpDocBorder",  { bg = "NONE" })
end
blink_hl_transparent()
vim.api.nvim_create_autocmd("ColorScheme", { callback = blink_hl_transparent })
