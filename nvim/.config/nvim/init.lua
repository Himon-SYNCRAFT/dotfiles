vim.cmd [[
	autocmd Vimenter * hi Normal guibg=NONE ctermbg=NONE
    set background=dark
    "" let g:everforest_transparent_background = 1
    "" let g:everforest_background = 'hard'
	"" silent! colorscheme cyberpunk
    "" silent! colorscheme everforest
    "" silent! colorscheme onedark
    silent! colorscheme dracula
	let mapleader=','
]]

require "plugins2"
require "statusline"
require "mappings"
require "telescope_config"
require "lint_config"

-- vim.g.dashboard_custom_section={
--     buffer_list = {
--         {
--             description = 'ﱮ Projects               , r l',
--             command = ":lua require('telescope_config').repo_list()"
--         },
--         {
--             description = ' New File',
--             command = ":DashboardNewFile"
--         },
--     }
-- }
vim.g.dashboard_custom_section={
    buffer_list = {
        {
            description = 'ﱮ Projects               , r l',
            command = ":lua require('telescope_config').repo_list()"
        }
    }
}

-- silent! colorscheme cyberpunk
vim.cmd [[
    filetype plugin indent on
    set nocompatible

    set fileformats=unix,dos,mac
    set noswapfile

	syntax on
	set ruler
	set number
	set relativenumber
	set colorcolumn=80
	" IndentLine
	let g:indentLine_enabled = 1
	let g:indentLine_concealcursor = 0
	let g:indentLine_char = '┆'
	let g:indentLine_faster = 1

	"" Fix backspace indent
	set backspace=indent,eol,start

	set tabstop=4
	set softtabstop=0
	set shiftwidth=4
	set expandtab

	noremap <C-j> <C-w>j
	noremap <C-k> <C-w>k
	noremap <C-l> <C-w>l
	noremap <C-h> <C-w>h

	if has('unnamedplus')
	    set clipboard=unnamed,unnamedplus
	endif

	noremap <Leader>h :<C-u>split<CR>
	noremap <Leader>v :<C-u>vsplit<CR>

	set ignorecase
	set smartcase

	if filereadable(expand("~/.vim/.coc.vimrc"))
	    source ~/.vim/.coc.vimrc
	endif

    function! FixIndentAndTrailingWhitespace()
        let l:save_cursor = getpos(".")
        execute "normal :FixWhiteSpace<CR>"
        execute "normal gg=G"
        call setpos('.', l:save_cursor)
    endfunction

    " python
    " vim-python
    augroup vimrc-python
        autocmd!
        autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=8 colorcolumn=79
                    \ formatoptions+=croq softtabstop=4
                    \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
    augroup END

    " vim-javascript
    augroup vimrc-javascript
        autocmd!
        " autocmd FileType javascript setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
        autocmd FileType javascript setl tabstop=2|setl shiftwidth=2|setl expandtab softtabstop=2
    augroup END

    nnoremap <silent> <F2> :Ranger<CR>
    nnoremap <silent> <F3> :RangerWorkingDirectory<CR>

    " Private dir for UltiSnip snippets
    set rtp+=~/.vim/UltiSnips/
    let g:UltiSnipsSnippetsDir = $HOME."/.vim/UltiSnips"
    let g:UltiSnipsSnippetDirectories=[$HOME."/.vim/UltiSnips"]

    "" Vmap for maintain Visual Mode after shifting > and <
    vmap < <gv
    vmap > >gv

    "" Remember cursor position
    augroup vimrc-remember-cursor-position
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END

    au BufWritePost <buffer> lua require('lint').try_lint()

    let g:dashboard_default_executive = 'telescope'

]]

