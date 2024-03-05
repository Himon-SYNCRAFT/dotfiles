require("plugins")
require("user.cmp")
-- require("user.debugging")
-- require("user.dressing")
require("user.gitsigns")
require("user.lsp")
require("user.nullls")
require("user.ranger")
require("user.telescope")
require("user.treesitter")
require("user.lightbulb")
-- require("user.markdown_previewer")
require("user.theme")
-- require "user.obsidian"
-- require("user.noice")
-- require "statusline"
require("native_statusline")
require("mappings")

-- require('virt-column').setup({virtcolumn = "80", char = '|'})

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
