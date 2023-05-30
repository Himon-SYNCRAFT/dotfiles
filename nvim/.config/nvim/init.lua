require "plugins"
require "user.cmp"
require "user.debugging"
require "user.dressing"
require "user.gitsigns"
require "user.lsp"
require "user.nullls"
require "user.ranger"
require "user.telescope"
require "user.treesitter"
require "user.lightbulb"
require "user.markdown_previewer"
require "statusline"
require "mappings"

vim.g.catppuccin_flavour = "macchiato" -- latte, frappe, macchiato, mocha

-- require("catppuccin").setup({
--     dim_inactive = {enabled = false, shade = "dark", percentage = 0.5},
--     transparent_background = true
-- })

-- vim.cmd [[colorscheme catppuccin]]
vim.cmd [[colorscheme tokyonight-storm]]

require('tokyonight').setup({
    style = 'storm',
    transparent = true,
    terminal_colors = true,
    dim_inactive = {enabled = false, shade = "dark", percentage = 0.5},
    lualine_bold = true,
    styles = {
        keywords = {bold = true, italic = false},
        functions = {bold = true, italic = false},
        variables = {italic = false}
    }
})

require('virt-column').setup({virtcolumn = "80", char = '｜'})

vim.cmd [[
	autocmd Vimenter * hi Normal guibg=NONE ctermbg=NONE
    set background=dark
    set fcs=eob:\ 
	"" silent! colorscheme cyberpunk
    "" silent! colorscheme dracula
]]

vim.fn.sign_define("DiagnosticSignError",
                   {texthl = "DiagnosticSignError", text = "󰅙", numhl = ""})

vim.fn.sign_define("DiagnosticSignWarn",
                   {texthl = "DiagnosticSignWarn", text = "󰀦", numhl = ""})

vim.fn.sign_define("DiagnosticSignHint",
                   {texthl = "DiagnosticSignHint", text = "󰌵", numhl = ""})

vim.fn.sign_define("DiagnosticSignInformation", {
    texthl = "DiagnosticSignInformation",
    text = "󰀨",
    numhl = ""
})

vim.cmd [[
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

	" IndentLine
	" let g:indentLine_enabled = 1
	" let g:indentLine_concealcursor = 0
	" let g:indentLine_char = '┆'
	" let g:indentLine_faster = 1
    let g:indentLine_loaded = 0

    set laststatus=3

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

"	if filereadable(expand("~/.vim/.coc.vimrc"))
"	    source ~/.vim/.coc.vimrc
"	endif

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
        autocmd FileType python setlocal expandtab shiftwidth=4 tabstop=4 colorcolumn=79
                    \ formatoptions+=croq softtabstop=4
                    \ cinwords=if,elif,else,for,while,try,except,finally,def,class,with
    augroup END

    " vim-javascript
    augroup vimrc-javascript
        autocmd!
        autocmd FileType javascript setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
        " autocmd FileType javascript setl tabstop=2|setl shiftwidth=2|setl expandtab softtabstop=2
    augroup END

    " ocaml
    augroup vimrc-ocaml
        autocmd!
        autocmd FileType ocaml setl tabstop=2|setl shiftwidth=2|setl expandtab softtabstop=2
    augroup END

    " ocaml
    augroup vimrc-gleam
        autocmd!
        autocmd FileType ocaml setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
    augroup END

    " Private dir for UltiSnip snippets
    set rtp+=~/.vim/UltiSnips/
    let g:UltiSnipsSnippetsDir = $HOME."/.vim/UltiSnips"
    let g:UltiSnipsSnippetDirectories=[$HOME."/.vim/UltiSnips"]

    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<c-b>"
    let g:UltiSnipsEditSplit="vertical"

    "" Remember cursor position
    augroup vimrc-remember-cursor-position
        autocmd!
        autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
    augroup END

    " au BufWritePost <buffer> lua require('lint').try_lint()

    " Disable default mappings
    let g:EasyMotion_do_mapping = 0

    " Turn on case-insensitive feature
    let g:EasyMotion_smartcase = 1

    " templates
    if has("autocmd")
      augroup templates
        autocmd BufNewFile *.php 0r ~/.vim/templates/skeleton.php
      augroup END
    endif

    augroup vimrc-php
        autocmd!
        autocmd FileType php nmap <Leader>m :PhpactorContextMenu<CR>
        autocmd FileType php inoremap .. ->
        autocmd FileType php nnoremap ; A;
        autocmd FileType php setl tabstop=4|setl shiftwidth=4|setl expandtab softtabstop=4
    augroup END

    augroup vimrc-rust
        autocmd!
        autocmd FileType rust nnoremap ; A;
    augroup END
]]
