-- lua/plugins/lsp.lua

require("mason").setup({})

require("mason-tool-installer").setup({
	ensure_installed = {
		"emmet_language_server",
		"gofumpt",
		"goimports-reviser",
		"golangci-lint",
		"golines",
		"gopls",
		"intelephense",
		"kulala-fmt",
		"php-cs-fixer",
		"phpactor",
		"phpcs",
		"phpstan",
		"prettierd",
		"pyright",
		"rust-analyzer",
		"rustfmt",
		"sleek",
		"stylua",
		"templ",
		"typescript-language-server",
		"yamlfmt",
	},
})

-- capabilities (blink)
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- 🔥 GLOBAL CONFIG (zamiast powtarzania wszędzie)
vim.lsp.config("*", {
	capabilities = capabilities,
})

-- ========================
-- 🔗 LspAttach (zamiast on_attach)
-- ========================
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(args)
		local client = vim.lsp.get_client_by_id(args.data.client_id)
		local bufopts = { noremap = true, silent = true, buffer = args.buf }

		-- keymaps
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, bufopts)
		vim.keymap.set("n", "<space>d", vim.lsp.buf.signature_help, bufopts)
		vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
		vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
		vim.keymap.set("n", "<space><space>", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("v", "<space><space>", vim.lsp.buf.code_action, bufopts)
		vim.keymap.set("x", "<space><space>", vim.lsp.buf.code_action, bufopts)

		-- PHP
		vim.keymap.set("n", "<leader>ga", ":PhpactorGenerateAccessors<CR>", bufopts)
		vim.keymap.set("n", "<leader>gs", ":PhpactorGenerateMutators<CR>", bufopts)

		-- inlay hints
		if client.server_capabilities.inlayHintProvider then
			vim.lsp.inlay_hint.enable(true)
		end

		-- signature help
		vim.api.nvim_create_autocmd("CursorHoldI", {
			buffer = args.buf,
			callback = function()
				vim.lsp.buf.signature_help({ border = "rounded" })
			end,
		})

		-- intelephense fix
		if client.name == "intelephense" then
			client.server_capabilities.documentFormattingProvider = false
		end

		-- semantic tokens
		if client.server_capabilities.semanticTokensProvider then
			vim.lsp.semantic_tokens.enable(true)
			-- vim.lsp.semantic_tokens.start(args.buf, client.id)
			vim.lsp.semantic_tokens.force_refresh()
		end
	end,
})

-- ========================
-- 🧠 SERVERS
-- ========================

vim.lsp.config("bashls", {})
vim.lsp.config("marksman", {})
vim.lsp.config("clangd", {})
vim.lsp.config("zls", {})
vim.lsp.config("kulala_ls", {})
vim.lsp.config("cssls", {})
vim.lsp.config("jsonls", {})
vim.lsp.config("templ", {})

-- PHP
vim.lsp.config("intelephense", {
	cmd = { "intelephense", "--stdio" },
	init_options = {
		licenceKey = "/home/himon/intelephense/license.txt",
	},
	settings = {
		intelephense = {
			files = { maxSize = 4000000 },
			format = { enable = false },
		},
	},
})

-- GO
vim.lsp.config("gopls", {
	filetypes = { "go", "gomod", "gowork", "gotmpl" },
	root_markers = { "go.work", "go.mod", ".git" },
	settings = {
		gopls = {
			completeUnimported = true,
			usePlaceholders = true,
			analyses = { unusedparams = true },
			["formatting.gofumpt"] = true,
			["ui.inlayhint.hints"] = {
				compositeLiteralFields = true,
				constantValues = true,
				parameterNames = true,
			},
		},
	},
})

-- PYTHON
vim.lsp.config("pyright", {
	root_markers = {
		"WORKSPACE",
		"pyproject.toml",
		"setup.py",
		"setup.cfg",
		"requirements.txt",
		"Pipfile",
		"pyrightconfig.json",
	},
})

-- LUA
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = { globals = { "vim" } },
		},
	},
})

-- RUST
vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			check = { command = "clippy" },
			diagnostics = { styleLints = { enable = true } },
		},
	},
})

-- TS
vim.lsp.config("tsserver", {
	cmd = { "typescript-language-server", "--stdio" },
	filetypes = {
		"javascript",
		"javascriptreact",
		"javascript.jsx",
		"typescript",
		"typescriptreact",
		"typescript.tsx",
	},
	root_markers = { "package.json", "tsconfig.json", ".git" },
	settings = {
		implicitProjectConfiguration = { checkJs = true },
	},
})

-- EMMET
vim.lsp.config("emmet_language_server", {
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
	init_options = {
		showAbbreviationSuggestions = true,
		showExpandedAbbreviation = "always",
		showSuggestionsAsSnippets = false,
	},
})

-- ========================
-- 🚀 ENABLE
-- ========================
vim.lsp.enable({
	"bashls",
	"marksman",
	"clangd",
	"zls",
	"kulala_ls",
	"cssls",
	"jsonls",
	"templ",
	"intelephense",
	"gopls",
	"pyright",
	"lua_ls",
	"rust_analyzer",
	"tsserver",
	"emmet_language_server",
})
