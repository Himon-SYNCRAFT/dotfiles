return {
	"stevearc/conform.nvim",

	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				lua = { "stylua" },
				-- python = { "isort", "black" },
				-- You can customize some of the format options for the filetype (:help conform.format)
				rust = { "rustfmt", lsp_format = "fallback" },
				-- Conform will run the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
				go = { "gofumpt", "goimports-reviser", "golines" },
				php = { "php_cs_fixer" },
				c = { "clang-format" },
				templ = { "templ" },
				sql = { "sleek" },
			},
			format_on_save = {
				-- These options will be passed to conform.format()
				timeout_ms = 5000,
				lsp_format = "fallback",
			},
			notify_on_error = true,
			notify_no_formatters = true,
		})

		vim.keymap.set("n", "<space>f", function()
			conform.format({ async = true, timeout_ms = 5000 })
		end)
	end,
}
