return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")

		local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

		local sources = {
			null_ls.builtins.diagnostics.phpstan,
			null_ls.builtins.diagnostics.phpcs,
			-- null_ls.builtins.diagnostics.phpmd.with({
			-- 	extra_args = { "ruleset.xml" },
			-- }),
			null_ls.builtins.diagnostics.golangci_lint,
		}

		null_ls.setup({
			sources = sources,
			-- debug = true,
			debug = true,
			on_attach = function(client, bufnr)
				local bufopts = { noremap = true, silent = true, buffer = bufnr }

				-- if client.supports_method("textDocument/formatting") then
				--     vim.keymap.set("n", "<space>f", function()
				--         vim.lsp.buf.format({ async = false, timeout_ms = 50000 })
				--     end, bufopts)
				--
				--     vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				--     vim.api.nvim_create_autocmd("BufWritePre", {
				--         group = augroup,
				--         buffer = bufnr,
				--         callback = function()
				--             vim.lsp.buf.format({ async = false, timeout_ms = 50000 })
				--         end,
				--     })
				-- end
			end,
			temp_dir = "/tmp/",
		})
	end,
}
