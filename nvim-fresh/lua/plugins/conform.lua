-- lua/plugins/conform.lua
local conform = require("conform")

conform.setup({
    formatters = {
        kulala = {
            command = "kulala-fmt",
            args = { "format", "$FILENAME" },
            stdin = false,
        },
    },
    formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        go = { "goimports-reviser", "golines", "gofumpt" },
        php = { "php_cs_fixer" },
        c = { "clang-format" },
        templ = { "templ" },
        sql = { "sleek" },
        mysql = { "sleek" },
        html = { "prettierd", "prettier", stop_after_first = true },
        template = { "prettierd", "prettier", stop_after_first = true },
        http = { "kulala" },
    },
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
    notify_on_error = true,
    notify_no_formatters = true,
})

vim.keymap.set("n", "<space>f", function()
    conform.format({ async = false, timeout_ms = 10000, lsp_format = "fallback" })
end)
