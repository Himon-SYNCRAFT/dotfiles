-- lua/pack.lua
--
-- WAŻNE — kroki budowania po pierwszej instalacji (jednorazowe):
--   telescope-fzf-native:  cd ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim && make
--   LuaSnip jsregexp:      cd ~/.local/share/nvim/site/pack/core/opt/LuaSnip && make install_jsregexp
--   treesitter parsery:    :TSUpdate  (uruchomić z poziomu nvim)

vim.pack.add({
	-- Zależności
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/nvim-tree/nvim-web-devicons",

	-- LSP
	"https://github.com/neovim/nvim-lspconfig",
	"https://github.com/williamboman/mason.nvim",
	"https://github.com/williamboman/mason-lspconfig.nvim",
	"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

	-- Completion
	"https://github.com/hrsh7th/nvim-cmp",
	"https://github.com/hrsh7th/cmp-nvim-lsp",
	"https://github.com/hrsh7th/cmp-buffer",
	"https://github.com/hrsh7th/cmp-path",
	"https://github.com/hrsh7th/cmp-cmdline",
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.5.0", build = "make install_jsregexp" },

	-- Treesitter
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

	-- Telescope
	"https://github.com/nvim-telescope/telescope.nvim",
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	"https://github.com/nvim-telescope/telescope-file-browser.nvim",
	"https://github.com/cljoly/telescope-repo.nvim",

	-- File explorer
	"https://github.com/echasnovski/mini.files",

	-- Git
	"https://github.com/lewis6991/gitsigns.nvim",

	-- Formatter + Linter
	"https://github.com/stevearc/conform.nvim",
	"https://github.com/mfussenegger/nvim-lint",

	-- Diagnostics panel
	"https://github.com/folke/trouble.nvim",

	-- Theme
	"https://github.com/rebelot/kanagawa.nvim",

	-- Session
	"https://github.com/rmagatti/auto-session",

	-- DB
	"https://github.com/tpope/vim-dadbod",
	"https://github.com/kristijanhusak/vim-dadbod-ui",
	"https://github.com/kristijanhusak/vim-dadbod-completion",

	-- HTTP
	"https://github.com/mistweaverco/kulala.nvim",

	-- Lua dev
	"https://github.com/folke/lazydev.nvim",

	-- Editing helpers
	"https://github.com/echasnovski/mini.pairs",
	"https://github.com/echasnovski/mini.surround",

	-- AI completion
	"https://github.com/Exafunction/codeium.vim",

	-- PHP
	{ src = "https://github.com/phpactor/phpactor", build = "composer install" },

	-- Misc
	"https://github.com/joerdav/templ.vim",
	"https://github.com/echasnovski/mini.notify",
}, { confirm = false })
