vim.g.mapleader = ","
vim.o.background = "light"
-- vim.o.background = "dark"
vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos"

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

vim.filetype.add({
	pattern = {
		["%.env%.[%w_.-]+"] = "sh",
	},
})

require("lazy").setup("plugins", {
	performance = {
		cache = {
			enabled = true,
		},
	},
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BlinkCmpAccept",
	callback = function(ev)
		local item = ev.data.item
		if item.kind == require("blink.cmp.types").CompletionItemKind.Snippet then
			vim.defer_fn(function()
				require("blink.cmp").show()
			end, 10)
		end
	end,
})

require("statusline")
require("mappings")
require("user.diagnostic")

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
    " set signcolumn=yes
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

    set completeopt=menu,menuone,noselect

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
]])
