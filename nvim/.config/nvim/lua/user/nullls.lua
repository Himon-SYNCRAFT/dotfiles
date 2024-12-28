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
