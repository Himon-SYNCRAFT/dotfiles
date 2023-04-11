local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local sources = {
    null_ls.builtins.diagnostics.phpstan, null_ls.builtins.diagnostics.phpcs,
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.formatting.phpcsfixer,
    null_ls.builtins.formatting.prettier, null_ls.builtins.formatting.sqlformat,
    null_ls.builtins.formatting.lua_format

    -- null_ls.builtins.code_actions.refactoring,
}

null_ls.setup({
    sources = sources,
    debug = true,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.api.nvim_clear_autocmds({group = augroup, buffer = bufnr})
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({
                        bufnr = bufnr,
                        filter = function(c)
                            return c.name == "null-ls"
                        end
                    })
                end
            })
        end
    end
})
