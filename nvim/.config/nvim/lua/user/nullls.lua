local null_ls = require("null-ls")

local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

local sources = {
	null_ls.builtins.diagnostics.phpstan,
	null_ls.builtins.diagnostics.phpcs,
	null_ls.builtins.formatting.phpcsfixer,
	-- null_ls.builtins.formatting.prettier,
	null_ls.builtins.formatting.stylua,
	null_ls.builtins.formatting.gofumpt,
	null_ls.builtins.formatting.goimports_reviser,
	null_ls.builtins.formatting.golines,
	null_ls.builtins.formatting.ocamlformat,
	null_ls.builtins.formatting.prettierd,
	null_ls.builtins.diagnostics.phpmd.with({
		extra_args = { "ruleset.xml" },
	}),
}

if vim.fn.executable("prettier") == 1 then
	sources[#sources + 1] = null_ls.builtins.formatting.prettier.with({
		filetypes = { "twig" },
	})
end

null_ls.setup({
	sources = sources,
	debug = true,
	on_attach = function(client, bufnr)
		local bufopts = { noremap = true, silent = true, buffer = bufnr }

		if client.supports_method("textDocument/formatting") then
			vim.keymap.set("n", "<space>f", vim.lsp.buf.format, bufopts)

			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({ async = false })
				end,
			})
		end
	end,
	temp_dir = "/tmp/",
})
