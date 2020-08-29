" Palette
" black         #312e39
" blue1         #342d59
" blue2         #3e518e
" blue3         #6262ae
" blue4         #871ff5
" brown1        #978979
" brown2        #afa38b
" darkbrown     #8a7c6f
" magenta1      #c72e68
" magenta2      #ff2975
" magenta3      #f022fd
" orange        #f28920
" skincolor     #f9c2a0
" white         #ebdbb2
" yellow        #f8cd1a

" Normal mode
" (Dark)
let s:N1 = [ '#ebdbb2' , '#312e39' , 189 , 55 ] " guifg guibg ctermfg ctermbg
let s:N2 = [ '#ebdbb2' , '#342d59' , 189 , 56  ] " guifg guibg ctermfg ctermbg
let s:N3 = [ '#ebdbb2' , '#3e518e' , 189 , 57  ] " guifg guibg ctermfg ctermbg

" Insert mode
let s:I1 = [ '#ebdbb2' , '#c72e68' , 255 , 125  ] " guifg guibg ctermfg ctermbg
let s:I2 = [ '#ebdbb2' , '#ff2975' , 255  , 161  ] " guifg guibg ctermfg ctermbg
let s:I3 = [ '#ebdbb2' , '#f022fd' , 255 , 162  ] " guifg guibg ctermfg ctermbg

" Visual mode
let s:V1 = [ '#ebdbb2' , '#f28920' , 232 , 184 ] " guifg guibg ctermfg ctermbg
let s:V2 = [ '#ebdbb2' , '#f8cd1a' , 232 , 184  ] " guifg guibg ctermfg ctermbg
let s:V3 = [ '#ebdbb2' , '#f9c2a0' , 232 , 184  ] " guifg guibg ctermfg ctermbg

" Replace mode
let s:RE = [ '#ebdbb2' , '#978979' , 59  , 203 ] " guifg guibg ctermfg ctermbg

let g:airline#themes#cyberpunk#palette = {}

let g:airline#themes#cyberpunk#palette.normal = airline#themes#generate_color_map(s:N1, s:N2, s:N3)

let g:airline#themes#cyberpunk#palette.insert = airline#themes#generate_color_map(s:I1, s:I2, s:I3)
let g:airline#themes#cyberpunk#palette.insert_replace = {
            \ 'airline_a': [ s:RE[0]   , s:I1[1]   , s:RE[1]   , s:I1[3]   , ''     ] }

let g:airline#themes#cyberpunk#palette.visual = airline#themes#generate_color_map(s:V1, s:V2, s:V3)

let g:airline#themes#cyberpunk#palette.replace = copy(g:airline#themes#cyberpunk#palette.normal)
let g:airline#themes#cyberpunk#palette.replace.airline_a = [ s:RE[0] , s:RE[1] , s:RE[2] , s:RE[3] , '' ]

let s:IA = [ s:N1[1] , s:N3[1] , s:N1[3] , s:N3[3] , '' ]
let g:airline#themes#cyberpunk#palette.inactive = airline#themes#generate_color_map(s:IA, s:IA, s:IA)

