local kind_icons = {
    Text = "",
    Method = "",
    Function = "󰊕",
    Constructor = "",
    Field = "󰭷",
    Variable = "󰫧",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰓹",
    Unit = "",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󱓉",
    TypeParameter = "",
    Codeium = "",
}

return {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
        opts.sources = opts.sources or {}
        table.insert(opts.sources, {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        })
    end,
    config = function()
        local cmp = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
            completion = {
                completeopt = "menu,menuone,fuzzy",
            },
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end,
            },

            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },

            formatting = {
                format = function(entry, vim_item)
                    vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
                    return vim_item
                end,
            },

            mapping = {
                ["<Down>"] = cmp.mapping(
                    cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Select,
                    }),
                    { "i" }
                ),
                ["<Up>"] = cmp.mapping(
                    cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Select,
                    }),
                    { "i" }
                ),
                ["<C-n>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<C-p>"] = cmp.mapping({
                    i = function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                        else
                            fallback()
                        end
                    end,
                }),
                ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
                ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
                ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                ["<C-e>"] = cmp.mapping({
                    i = cmp.mapping.close(),
                    c = cmp.mapping.close(),
                }),
                ["<CR>"] = cmp.mapping({
                    i = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    }),
                }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),

                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if luasnip.locally_jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },

            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "luasnip" },
                { name = "codeium",              keyword_length = 2 },
                { name = "path" },
                { name = "orgmode" },
                { name = "vim-dadbod-completion" },
            }, { { name = "buffer", keyword_length = 5 } }),
        })

        local cmdline_mapping = {
            ["<C-n>"] = {
                c = function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    else
                        fallback()
                    end
                end,
            },
            ["<C-p>"] = {
                c = function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end,
            },
            ["<C-e>"] = { c = cmp.mapping.close() },

            ["<CR>"] = cmp.mapping({
                c = function(fallback)
                    if cmp.get_selected_entry() == nil then
                        cmp.mapping.close()
                        fallback()
                    elseif cmp.visible() then
                        cmp.confirm({
                            behavior = cmp.ConfirmBehavior.Replace,
                            select = false,
                        })
                    else
                        fallback()
                    end
                end,
            }),
        }

        -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline("/", {
            completion = {
                completeopt = "menu,menuone,fuzzy,noinsert,noselect",
            },
            mapping = cmdline_mapping,
            sources = { { name = "buffer", keyword_length = 5 } },
        })

        -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmdline_mapping,
            completion = {
                completeopt = "menu,menuone,noselect,fuzzy",
            },
            sources = cmp.config.sources({ { name = "path" } }, { { name = "cmdline", keyword_length = 3 } }),
        })

        vim.cmd([[
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })

    " Source is automatically added, you just need to include it in the chain complete list
    let g:completion_chain_complete_list = {
        \   'sql': [
        \    {'complete_items': ['vim-dadbod-completion']},
        \   ],
        \ }
    " Make sure `substring` is part of this list. Other items are optional for this completion source
    let g:completion_matching_strategy_list = ['exact', 'substring']
    " Useful if there's a lot of camel case items
    let g:completion_matching_ignore_case = 1

    let g:vim_dadbod_completion_mark = '󰆼'
]])
    end,
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
    },
}
