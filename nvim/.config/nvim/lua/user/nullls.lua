local null_ls = require("null-ls")

local sources = {
    null_ls.builtins.diagnostics.phpstan,
    null_ls.builtins.diagnostics.phpcs,
    null_ls.builtins.formatting.autopep8,
    null_ls.builtins.code_actions.refactoring,
    null_ls.builtins.formatting.prettier,
}

null_ls.setup({
    sources = sources
})

