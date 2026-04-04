-- init.lua
vim.g.mapleader = ","
vim.o.background = "dark"
vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos"

vim.filetype.add({
    pattern = {
        ["%.env%.[%w_.-]+"] = "sh",
    },
})

-- Bootstrap: pobiera/rejestruje wszystkie pluginy
require("pack")

-- theme najpierw — żeby floaty i inne okna miały kolory
require("plugins.theme")
require("plugins.lsp")
require("plugins.cmp")
require("plugins.luasnip")
require("plugins.codeium")
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.mini_files")
require("plugins.gitsigns")
require("plugins.conform")
require("plugins.lint")
require("plugins.trouble")
require("plugins.autosession")
require("plugins.dadbod")
require("plugins.kulala")
require("plugins.lazydev")
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
    set signcolumn=no
    set scrolloff=8

    let g:indentLine_loaded = 0

    set laststatus=3
    set cmdheight=0

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

    set updatetime=300

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
