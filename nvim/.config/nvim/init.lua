vim.g.mapleader = ","
vim.o.background = "light"

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{ "nekonako/xresources-nvim" },
	{ "sindrets/diffview.nvim" },
	{ "nvim-lua/plenary.nvim" },
	{ "tpope/vim-repeat" },
	{ "tpope/vim-surround" },
	{ "tpope/vim-commentary" },
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		build = "make install_jsregexp",
		dependencies = {
			"saadparwaiz1/cmp_luasnip",
		},
	},
	{ "Raimondi/delimitMate" },
	{
		"francoiscabrol/ranger.vim",
		dependencies = {
			{ "rbgrouleff/bclose.vim" },
		},
	},

	-- ai
	{
		"Exafunction/codeium.vim",
	},

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		init = function(plugin)
			require("lazy.core.loader").add_to_rtp(plugin)
		end,
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				auto_install = true,
				ensure_installed = {
					"bash",
					"c",
					"cmake",
					"comment",
					"cpp",
					"css",
					"diff",
					"dockerfile",
					"dot",
					"fish",
					"go",
					"groovy",
					"html",
					"ini",
					"json",
					"lua",
					"make",
					"ocaml",
					"ocaml_interface",
					"org",
					"php",
					"phpdoc",
					"python",
					"scss",
					"toml",
					"templ",
					"tsx",
					"twig",
					"typescript",
					"yaml",
					"markdown",
					"markdown_inline", -- , 'javascript',
				},

				highlight = {
					enable = true,
					additional_vim_regex_highlighting = { "org", "markdown" },
				},

				indent = {
					enable = true,
					disable = { "python" },
				},
			})
		end,
	},

	-- Telescope Extensions
	{ "nvim-telescope/telescope.nvim" },
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "cljoly/telescope-repo.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "stevearc/dressing.nvim" },
	{
		"lewis6991/gitsigns.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"phpactor/phpactor",
	},
	{
		"folke/trouble.nvim",
		opts = {},
		cmd = "Trouble",
	},

	-- lsp
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"nvimtools/none-ls.nvim",
		},
	},
	{
		"ray-x/lsp_signature.nvim",
		event = "VeryLazy",
		opts = {},
		config = function(_, opts)
			require("lsp_signature").setup(opts)
		end,
	},

	-- debugging
	{
		"mfussenegger/nvim-dap",
	},
	{
		"leoluz/nvim-dap-go",
		config = function()
			require("dap-go").setup()
		end,
	},
	{
		"theHamsta/nvim-dap-virtual-text",
		config = function()
			require("nvim-dap-virtual-text").setup()
		end,
	},
	{
		"rcarriga/nvim-dap-ui",
		dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
		config = function()
			require("dapui").setup()
		end,
	},

	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
		},
	},

	{
		"kosayoda/nvim-lightbulb",
		dependencies = "antoinemadec/FixCursorHold.nvim",
	},

	{ "nvim-tree/nvim-web-devicons" },

	-- db
	{
		"tpope/vim-dadbod",
		dependencies = {
			"kristijanhusak/vim-dadbod-ui",
			"kristijanhusak/vim-dadbod-completion",
		},
	},

	{
		"rmagatti/auto-session",
		config = function()
			require("auto-session").setup({
				log_level = "error",
				auto_session_suppress_dirs = {
					"~/",
					"~/Projects",
					"~/Downloads",
					"/",
				},
			})
		end,
	},

	{ "tjdevries/templ.nvim" },
})

require("user.dressing")
require("user.gitsigns")
require("user.ranger")
require("user.telescope")
-- require("user.treesitter")
require("user.lsp")
require("user.cmp")
require("user.lightbulb")
require("user.nullls")
require("native_statusline")
require("mappings")
require("user.debugging")
require("user.theme")
require("user.luasnip")

vim.cmd([[
    filetype plugin indent on
    set nocompatible

    set fileformats=unix,dos,mac
    set noswapfile

	syntax on
	set ruler
	set number
	set relativenumber
	" set colorcolumn=80
    set signcolumn=yes
    set scrolloff=8

    let g:indentLine_loaded = 0

    set laststatus=3
    set cmdheight=0

	"" Fix backspace indent
	set backspace=indent,eol,start

	set tabstop=4
	set softtabstop=0
	set shiftwidth=4
	set expandtab
    set shiftround
    set nofoldenable

    set splitright
    set splitbelow

    set shortmess=filnxtToOFcsWAICS

	if has('unnamedplus')
	    set clipboard=unnamed,unnamedplus
	endif

	set ignorecase
	set smartcase

    " vim-javascript
    augroup vimrc-javascript
        autocmd!
        autocmd FileType javascript setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
        " autocmd FileType javascript setl tabstop=2|setl shiftwidth=2|setl expandtab softtabstop=2
    augroup END

    let g:codeium_no_map_tab = 1
    let g:codeium_filetypes = { "sql": v:false }

    let g:db_ui_auto_execute_table_helpers = 1
    let g:db_ui_table_helpers = {
    \   'postgresql': {
    \     'Count': 'SELECT count(*) FROM "{table}"',
    \     'Where': 'SELECT count(*) FROM "{table}" WHERE'
    \   },
    \   'sqlite': {
    \     'Count': 'SELECT count(*) FROM "{table}"',
    \     'Where': 'SELECT count(*) FROM "{table}" WHERE'
    \   },
    \   'mysql': {
    \     'Count': 'SELECT count(*) FROM "{table}"',
    \     'Where': 'SELECT count(*) FROM "{table}" WHERE'
    \   },
    \ }

    "" Remember cursor position
    augroup vimrc-remember-cursor-position
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END

    augroup vimrc-php
        autocmd!
        autocmd FileType php inoremap .. ->
        autocmd FileType php nnoremap ; A;<ESC>
        autocmd FileType php setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
    augroup END
]])
