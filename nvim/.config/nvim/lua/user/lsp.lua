vim.cmd([[
    set completeopt=menu,menuone,noselect
]])

require("mason").setup({})
require("mason-lspconfig").setup({
	automatic_installation = true,
	ensured_installed = {
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
		"templ",
		"typescript-language-server",
	},
})

local util = require("lspconfig/util")
local lspconfig = require("lspconfig")
local lsp_signature = require("lsp_signature")

local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

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

local border = {
	{ "┌", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "┐", "FloatBorder" },
	{ "│", "FloatBorder" },
	{ "┘", "FloatBorder" },
	{ "─", "FloatBorder" },
	{ "└", "FloatBorder" },
	{ "│", "FloatBorder" },
}

local handlers = {
	["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = border }),
}

local on_attach = function(client, bufnr)
	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	local bufopts = { noremap = true, silent = true, buffer = bufnr }

	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
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
	init_options = { licenceKey = "/home/himon/intelephense/license.txt" },
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

lspconfig.sqlls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
})

lspconfig.sqls.setup({
	on_attach = on_attach,
	capabilities = capabilities,
	handlers = handlers,
})

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
