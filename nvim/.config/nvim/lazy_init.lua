vim.g.mapleader = ","

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
	{ "rose-pine/neovim", name = "rose-pine" },
	{ "nvim-lua/plenary.nvim" },
	{ "tpope/vim-repeat" },
	{ "tpope/vim-surround" },
	{ "tpope/vim-commentary" },
	{
		"SirVer/ultisnips",
		-- dependencies = {
		--     { "honza/vim-snippets", rtp = "." }
		-- },
		config = function()
			vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
			vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
			vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
			vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
			vim.g.UltiSnipsRemoveSelectModeMappings = 0
		end,
	},
	{ "Raimondi/delimitMate" },
	{
		"francoiscabrol/ranger.vim",
		dependencies = {
			{ "rbgrouleff/bclose.vim" },
		},
	},

	-- ai
	{ "Exafunction/codeium.vim" },

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "VeryLazy" },
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
	-- {
	-- 	"p00f/nvim-ts-rainbow",
	-- 	dependencies = {
	-- 		"nvim-treesitter/nvim-treesitter",
	-- 	},
	-- },

	-- Telescope Extensions
	{ "nvim-telescope/telescope.nvim" },
	{ "nvim-telescope/telescope-file-browser.nvim" },
	{ "cljoly/telescope-repo.nvim" },
	{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	{ "stevearc/dressing.nvim" },
	{ "lewis6991/gitsigns.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
	{ "phpactor/phpactor" },
	{ "folke/trouble.nvim" },

	-- lsp
	{
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"neovim/nvim-lspconfig",
		"nvimtools/none-ls.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-cmdline",
		"hrsh7th/nvim-cmp",
		"quangnguyen30192/cmp-nvim-ultisnips",
		"ray-x/lsp_signature.nvim",
	},

	{
		"kosayoda/nvim-lightbulb",
		dependencies = "antoinemadec/FixCursorHold.nvim",
	},

	{ "nvim-tree/nvim-web-devicons" },

	-- db
	{ "tpope/vim-dadbod" },
	{ "kristijanhusak/vim-dadbod-ui" },
	{ "kristijanhusak/vim-dadbod-completion" },

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
})

require("user.cmp")
require("user.dressing")
require("user.gitsigns")
require("user.lsp")
require("user.nullls")
require("user.ranger")
require("user.telescope")
-- require("user.treesitter")
require("user.lightbulb")
require("user.theme")
require("native_statusline")
require("mappings")

vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅙", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀦", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌵", numhl = "" })
vim.fn.sign_define("DiagnosticSignInformation", {
	texthl = "DiagnosticSignInformation",
	text = "󰀨",
	numhl = "",
})

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
    set signcolumn=no
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

    " Private dir for UltiSnip snippets
    set rtp+=~/.vim/UltiSnips/
    let g:UltiSnipsSnippetsDir = $HOME."/.vim/UltiSnips"
    let g:UltiSnipsSnippetDirectories=[$HOME."/.vim/UltiSnips"]

    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<c-b>"
    let g:UltiSnipsEditSplit="vertical"

    let g:codeium_no_map_tab = 1

    let g:db_ui_auto_execute_table_helpers = 1

    "" Remember cursor position
    augroup vimrc-remember-cursor-position
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END

    " Disable default mappings
    let g:EasyMotion_do_mapping = 0

    " Turn on case-insensitive feature
    let g:EasyMotion_smartcase = 1

    augroup vimrc-php
        autocmd!
        autocmd FileType php nmap <Leader>m :PhpactorContextMenu<CR>
        autocmd FileType php inoremap .. ->
        autocmd FileType php nnoremap ; A;
        autocmd FileType php setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
    augroup END
]])
