local function none_ls()
    local null_ls = require("null-ls")

    local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

    local sources = {
        null_ls.builtins.diagnostics.phpstan,
        null_ls.builtins.diagnostics.phpcs,
        -- null_ls.builtins.diagnostics.phpmd,
        null_ls.builtins.formatting.phpcsfixer,
        -- null_ls.builtins.formatting.phpcbf,
        -- null_ls.builtins.formatting.prettier,
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports_reviser,
        null_ls.builtins.formatting.golines,
        null_ls.builtins.formatting.prettierd,
        null_ls.builtins.diagnostics.phpmd.with({
            extra_args = { "ruleset.xml" },
        }),
        null_ls.builtins.formatting.clang_format,
        -- null_ls.builtins.code_actions.refactoring,
    }

    null_ls.setup({
        sources = sources,
        -- debug = true,
        debug = true,
        on_attach = function(client, bufnr)
            local bufopts = { noremap = true, silent = true, buffer = bufnr }

            if client.supports_method("textDocument/formatting") then
                vim.keymap.set("n", "<space>f", function()
                    vim.lsp.buf.format({ async = true, timeout_ms = 5000 })
                end, bufopts)

                vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
                vim.api.nvim_create_autocmd("BufWritePre", {
                    group = augroup,
                    buffer = bufnr,
                    callback = function()
                        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                    end,
                })
            end
        end,
        temp_dir = "/tmp/",
    })
end

return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "nvimtools/none-ls.nvim",
            "saghen/blink.cmp"
        },
        config = function()
            require("mason").setup({})
            require("mason-lspconfig").setup({
                automatic_installation = true,
                ensure_installed = {
                    "emmet_language_server",
                    "gofumpt",
                    "goimports-reviser",
                    "golines",
                    "gopls",
                    "intelephense",
                    "php-cs-fixer",
                    "phpactor",
                    "phpcs",
                    "phpstan",
                    "pyright",
                    "prettierd",
                    "templ",
                    "typescript-language-server",
                    "rust-analyzer",
                    "rustfmt",
                },
            })

            local util = require("lspconfig/util")
            local lspconfig = require("lspconfig")
            local lsp_signature = require("lsp_signature")
            local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

            -- local capabilities =
            --     require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
            -- local capabilities = vim.lsp.protocol.make_client_capabilities()
            local capabilities = require("blink.cmp").get_lsp_capabilities()

            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("UserLspConfig", {}),
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client.server_capabilities.inlayHintProvider then
                        vim.lsp.inlay_hint.enable(true)
                        -- vim.lsp.inlay_hint.enable(args.buf, true)
                    end
                end,
            })

            local handlers = {
                -- ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
                -- ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" }),
                -- ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" }),
            }

            local on_attach = function(client, bufnr)
                vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
                local bufopts = { noremap = true, silent = true, buffer = bufnr }

                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                -- vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "<space>d", vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "<space><space>", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("v", "<space><space>", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("x", "<space><space>", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("n", "<space>f", function()
                    vim.lsp.buf.format({ async = true, timeout_ms = 5000 })
                end, bufopts)

                if client.name == "intelephense" then
                    client.server_capabilities.documentFormattingProvider = false
                end

                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        group = augroup,
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                        end,
                    })
                end

                lsp_signature.on_attach({
                    bind = true, -- This is mandatory, otherwise border config won't get registered.
                    handler_opts = { border = "rounded" },
                }, bufnr)
            end

            -- TODO: może to się przyda
            -- require("mason-lspconfig").setup_handlers {
            --     function(server_name)
            --         require("lspconfig")[server_name].setup {
            --             on_attach = on_attach,
            --             capabilities = capabilities,
            --             handlers = handlers
            --         }
            --     end
            -- }

            lspconfig.bashls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
            })

            lspconfig.clangd.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
            })

            lspconfig.zls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
            })

            -- lspconfig.ccls.setup({
            -- 	on_attach = on_attach,
            -- 	capabilities = capabilities,
            -- 	handlers = handlers,
            -- })

            lspconfig.cssls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
            })

            lspconfig.intelephense.setup({
                init_options = {
                    licenceKey = "/home/himon/intelephense/license.txt",
                },
                settings = {
                    intelephense = {
                        files = {
                            maxSize = 4000000,
                        },
                    },
                },
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
            })

            lspconfig.gopls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
                filetypes = { "go", "gomod", "gowork", "gotmpl" },
                root_dir = util.root_pattern("go.work", "go.mod", ".git"),
                settings = {
                    gopls = {
                        completeUnimported = true,
                        usePlaceholders = true,
                        analyses = { unusedparams = true },
                        ["formatting.gofumpt"] = true,
                    },
                },
            })

            lspconfig.templ.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
            })

            lspconfig.jsonls.setup({ on_attach = on_attach, capabilities = capabilities })

            local python_root_files = {
                "WORKSPACE", -- added for Bazel; items below are from default config
                "pyproject.toml",
                "setup.py",
                "setup.cfg",
                "requirements.txt",
                "Pipfile",
                "pyrightconfig.json",
            }

            lspconfig.pyright.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                root_dir = util.root_pattern(unpack(python_root_files)),
                handlers = handlers,
            })

            -- lspconfig.sqlls.setup({
            -- 	on_attach = on_attach,
            -- 	capabilities = capabilities,
            -- 	handlers = handlers,
            -- })
            --
            -- lspconfig.sqls.setup({
            -- 	on_attach = on_attach,
            -- 	capabilities = capabilities,
            -- 	handlers = handlers,
            -- })

            lspconfig.lua_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })

            lspconfig.rust_analyzer.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
                settings = {
                    ["rust-analyzer"] = {
                        check = {
                            command = "clippy",
                        },
                        diagnostics = {
                            styleLints = {
                                enable = true,
                            },
                        },
                    },
                },
            })

            lspconfig.ts_ls.setup({
                on_attach = on_attach,
                capabilities = capabilities,
                handlers = handlers,
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "javascript.jsx",
                    "typescript",
                    "typescriptreact",
                    "typescript.tsx",
                },
            })

            capabilities.textDocument.completion.completionItem.snippetSupport = true

            lspconfig.emmet_language_server.setup({
                filetypes = {
                    "css",
                    "eruby",
                    "html",
                    "javascript",
                    "javascriptreact",
                    "less",
                    "sass",
                    "scss",
                    "pug",
                    "typescriptreact",
                    "twig",
                },
                -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
                -- **Note:** only the options listed in the table are supported.
                init_options = {
                    ---@type table<string, string>
                    includeLanguages = {},
                    --- @type string[]
                    excludeLanguages = {},
                    --- @type string[]
                    extensionsPath = {},
                    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
                    preferences = {},
                    --- @type boolean Defaults to `true`
                    showAbbreviationSuggestions = true,
                    --- @type "always" | "never" Defaults to `"always"`
                    showExpandedAbbreviation = "always",
                    --- @type boolean Defaults to `false`
                    showSuggestionsAsSnippets = false,
                    --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
                    syntaxProfiles = {},
                    --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
                    variables = {},
                },
            })

            none_ls()
        end,
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {},
        config = function(_, opts)
            require("lsp_signature").setup(opts)
        end,
    },
}
