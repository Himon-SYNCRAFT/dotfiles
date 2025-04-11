return {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },

    version = "1.*",
    -- version = "0.9.0",

    config = function(_, opts)
        require("blink-cmp").setup(opts)
        -- vim.api.nvim_create_autocmd('User', {
        --     pattern = 'BlinkCmpAccept',
        --     callback = function(ev)
        --         local item = ev.data.item
        --         if item.kind == require('blink.cmp.types').CompletionItemKind.Snippet then
        --             vim.defer_fn(function()
        --                 require('blink.cmp').show()
        --             end, 10)
        --         end
        --     end,
        -- })
    end,

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
        keymap = {
            preset = "none",
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<CR>"] = { "accept", "fallback" },
        },

        appearance = {
            nerd_font_variant = "mono",
        },

        completion = {
            trigger = {
                show_on_keyword = true,
            },
            list = {
                selection = {
                    preselect = true,
                    auto_insert = true,
                },
            },
            documentation = { auto_show = false },
            menu = {
                border = "rounded",
            }
        },

        cmdline = {
            enabled = true,
            keymap = {
                preset = "inherit",
            },
            completion = {
                menu = {
                    auto_show = true,
                },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
            },
        },

        sources = {
            default = { "lsp", "path", "snippets", "buffer", "cmdline" },
            providers = {
                dadbod = { module = "vim_dadbod_completion.blink" },
            },
            per_filetype = {
                sql = { "dadbod" },
            },
        },

        snippets = { preset = "luasnip" },
        signature = { enabled = false },

        fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
}
