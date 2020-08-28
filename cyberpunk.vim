" Name:         Cyberpunk
" Author:       d.zawlocki@syncraft.pl
" Maintainer:   d.zawlocki@syncraft.pl
" License:      Vim License (see `:help license`)
" Last Updated: pią, 28 sie 2020, 09:58:50

" Generated by Colortemplate v2.0.0

set background=dark

hi clear
if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'cyberpunk'

let s:t_Co = exists('&t_Co') && !empty(&t_Co) && &t_Co > 1 ? &t_Co : 2
let s:italics = (&t_ZH != '' && &t_ZH != '[7m') || has('gui_running')

hi! link Boolean Constant
hi! link Character Constant
hi! link Conditional Statement
hi! link Debug Special
hi! link Define PreProc
hi! link Delimiter Special
hi! link Exception Statement
hi! link Float Constant
hi! link Function Identifier
hi! link Include PreProc
hi! link Keyword Statement
hi! link Label Statement
hi! link Macro PreProc
hi! link Number Constant
hi! link Operator Statement
hi! link PopupSelected PmenuSel
hi! link PreCondit PreProc
hi! link QuickFixLine Search
hi! link Repeat Statement
hi! link SpecialChar Special
hi! link SpecialComment Special
hi! link StatusLineTerm StatusLine
hi! link StatusLineTermNC StatusLineNC
hi! link StorageClass Type
hi! link String Constant
hi! link Structure Type
hi! link Tag Special
hi! link Typedef Type
hi! link lCursor Cursor

if (has('termguicolors') && &termguicolors) || has('gui_running')
  let g:terminal_ansi_colors = ['#312e39', '#c72e68', '#978979', '#f28920',
        \ '#3e518e', '#ff2975', '#f022fd', '#ebdbb2', '#8a7c6f', '#ff2975',
        \ '#afa38b', '#f8cd1a', '#6262ae', '#f022fd', '#3e518e', '#f9c2a0']
  if get(g:, 'cyberpunk_transp_bg', 0) && !has('gui_running')
    hi Normal guifg=#ebdbb2 guibg=NONE guisp=NONE gui=NONE cterm=NONE
    hi Terminal guifg=#ebdbb2 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  else
    hi Normal guifg=#ebdbb2 guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
    hi Terminal guifg=#ebdbb2 guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  endif
  hi ColorColumn guifg=fg guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi Conceal guifg=#8a7c6f guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Cursor guifg=NONE guibg=NONE guisp=NONE gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi CursorColumn guifg=NONE guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi CursorLine guifg=NONE guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi CursorLineNr guifg=#f8cd1a guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi DiffAdd guifg=#978979 guibg=#312e39 guisp=NONE gui=reverse cterm=reverse
  hi DiffChange guifg=#6262ae guibg=#312e39 guisp=NONE gui=reverse cterm=reverse
  hi DiffDelete guifg=#c72e68 guibg=#312e39 guisp=NONE gui=reverse cterm=reverse
  hi DiffText guifg=#f28920 guibg=#312e39 guisp=NONE gui=bold,reverse cterm=bold,reverse
  hi Directory guifg=#978979 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi EndOfBuffer guifg=#ebdbb2 guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi ErrorMsg guifg=#312e39 guibg=#f022fd guisp=NONE gui=bold cterm=bold
  hi FoldColumn guifg=#8a7c6f guibg=NONE guisp=NONE gui=italic cterm=italic
  hi Folded guifg=#8a7c6f guibg=NONE guisp=NONE gui=italic cterm=italic
  hi IncSearch guifg=#f28920 guibg=#312e39 guisp=NONE gui=standout cterm=standout
  hi LineNr guifg=#978979 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi MatchParen guifg=NONE guibg=#312e39 guisp=NONE gui=bold cterm=bold
  hi ModeMsg guifg=#f8cd1a guibg=#312e39 guisp=NONE gui=bold cterm=bold
  hi MoreMsg guifg=#f8cd1a guibg=#312e39 guisp=NONE gui=bold cterm=bold
  hi NonText guifg=#8a7c6f guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi Pmenu guifg=#ebdbb2 guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi PmenuSbar guifg=NONE guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi PmenuSel guifg=#312e39 guibg=#6262ae guisp=NONE gui=bold cterm=bold
  hi PmenuThumb guifg=NONE guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi Question guifg=#f28920 guibg=#312e39 guisp=NONE gui=bold cterm=bold
  hi Search guifg=#f8cd1a guibg=#312e39 guisp=NONE gui=reverse cterm=reverse
  hi SignColumn guifg=NONE guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi SpecialKey guifg=#312e39 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi SpellBad guifg=NONE guibg=NONE guisp=#c72e68 gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
  hi SpellCap guifg=#978979 guibg=NONE guisp=#6262ae gui=NONE cterm=NONE
  hi SpellLocal guifg=NONE guibg=NONE guisp=#f022fd gui=NONE ctermfg=NONE ctermbg=NONE cterm=NONE
  hi SpellRare guifg=NONE guibg=NONE guisp=#ff2975 gui=reverse ctermfg=NONE ctermbg=NONE cterm=reverse
  hi StatusLine guifg=#8a7c6f guibg=#f9c2a0 guisp=NONE gui=NONE cterm=NONE
  hi StatusLineNC guifg=#312e39 guibg=#ebdbb2 guisp=NONE gui=NONE cterm=NONE
  hi TabLine guifg=#ebdbb2 guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi TabLineFill guifg=#8a7c6f guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi TabLineSel guifg=#978979 guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi Title guifg=#978979 guibg=#312e39 guisp=NONE gui=bold cterm=bold
  hi VertSplit guifg=#8a7c6f guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi Visual guifg=NONE guibg=#312e39 guisp=NONE gui=reverse cterm=reverse
  hi VisualNOS guifg=NONE guibg=#312e39 guisp=NONE gui=reverse cterm=reverse
  hi WarningMsg guifg=#f022fd guibg=#312e39 guisp=NONE gui=bold cterm=bold
  hi WildMenu guifg=#6262ae guibg=#312e39 guisp=NONE gui=bold cterm=bold
  hi Comment guifg=#8a7c6f guibg=NONE guisp=NONE gui=italic cterm=italic
  hi Constant guifg=#6262ae guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Number guifg=#871ff5 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Error guifg=#f022fd guibg=#312e39 guisp=NONE gui=bold,reverse cterm=bold,reverse
  hi Function guifg=#f28920 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Identifier guifg=#f28920 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Ignore guifg=#ebdbb2 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi PreProc guifg=#c72e68 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Include guifg=#6262ae guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Special guifg=#f28920 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Statement guifg=#ff2975 guibg=NONE guisp=NONE gui=bold cterm=bold
  hi Operator guifg=#6262ae guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi String guifg=#f8cd1a guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Type guifg=#c72e68 guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi Todo guifg=#ebdbb2 guibg=NONE guisp=NONE gui=bold,italic cterm=bold,italic
  hi Underlined guifg=#6262ae guibg=NONE guisp=NONE gui=NONE cterm=NONE
  hi CursorIM guifg=NONE guibg=fg guisp=NONE gui=NONE cterm=NONE
  hi ToolbarLine guifg=NONE guibg=#312e39 guisp=NONE gui=NONE cterm=NONE
  hi ToolbarButton guifg=#ebdbb2 guibg=#312e39 guisp=NONE gui=bold cterm=bold
  if !s:italics
    hi FoldColumn gui=NONE cterm=NONE
    hi Folded gui=NONE cterm=NONE
    hi Comment gui=NONE cterm=NONE
    hi Todo gui=bold cterm=bold
  endif
  unlet s:t_Co s:italics
  finish
endif

if s:t_Co >= 256
  if get(g:, 'cyberpunk_transp_bg', 0)
    hi Normal ctermfg=187 ctermbg=NONE cterm=NONE
    hi Terminal ctermfg=187 ctermbg=NONE cterm=NONE
  else
    hi Normal ctermfg=187 ctermbg=236 cterm=NONE
    if !has('patch-8.0.0616') " Fix for Vim bug
      set background=dark
    endif
    hi Terminal ctermfg=187 ctermbg=236 cterm=NONE
  endif
  hi ColorColumn ctermfg=fg ctermbg=236 cterm=NONE
  hi Conceal ctermfg=244 ctermbg=NONE cterm=NONE
  hi Cursor ctermfg=NONE ctermbg=NONE cterm=reverse
  hi CursorColumn ctermfg=NONE ctermbg=236 cterm=NONE
  hi CursorLine ctermfg=NONE ctermbg=236 cterm=NONE
  hi CursorLineNr ctermfg=220 ctermbg=236 cterm=NONE
  hi DiffAdd ctermfg=245 ctermbg=236 cterm=reverse
  hi DiffChange ctermfg=61 ctermbg=236 cterm=reverse
  hi DiffDelete ctermfg=161 ctermbg=236 cterm=reverse
  hi DiffText ctermfg=208 ctermbg=236 cterm=bold,reverse
  hi Directory ctermfg=245 ctermbg=NONE cterm=bold
  hi EndOfBuffer ctermfg=187 ctermbg=236 cterm=NONE
  hi ErrorMsg ctermfg=236 ctermbg=201 cterm=bold
  hi FoldColumn ctermfg=244 ctermbg=NONE cterm=italic
  hi Folded ctermfg=244 ctermbg=NONE cterm=italic
  hi IncSearch ctermfg=208 ctermbg=236 cterm=reverse
  hi LineNr ctermfg=245 ctermbg=NONE cterm=NONE
  hi MatchParen ctermfg=NONE ctermbg=236 cterm=bold
  hi ModeMsg ctermfg=220 ctermbg=236 cterm=bold
  hi MoreMsg ctermfg=220 ctermbg=236 cterm=bold
  hi NonText ctermfg=244 ctermbg=236 cterm=NONE
  hi Pmenu ctermfg=187 ctermbg=236 cterm=NONE
  hi PmenuSbar ctermfg=NONE ctermbg=236 cterm=NONE
  hi PmenuSel ctermfg=236 ctermbg=61 cterm=bold
  hi PmenuThumb ctermfg=NONE ctermbg=236 cterm=NONE
  hi Question ctermfg=208 ctermbg=236 cterm=bold
  hi Search ctermfg=220 ctermbg=236 cterm=reverse
  hi SignColumn ctermfg=NONE ctermbg=236 cterm=NONE
  hi SpecialKey ctermfg=236 ctermbg=NONE cterm=NONE
  hi SpellBad ctermfg=NONE ctermbg=NONE cterm=NONE
  hi SpellCap ctermfg=245 ctermbg=NONE cterm=NONE
  hi SpellLocal ctermfg=NONE ctermbg=NONE cterm=NONE
  hi SpellRare ctermfg=NONE ctermbg=NONE cterm=reverse
  hi StatusLine ctermfg=244 ctermbg=216 cterm=NONE
  hi StatusLineNC ctermfg=236 ctermbg=187 cterm=NONE
  hi TabLine ctermfg=187 ctermbg=236 cterm=NONE
  hi TabLineFill ctermfg=244 ctermbg=236 cterm=NONE
  hi TabLineSel ctermfg=245 ctermbg=236 cterm=NONE
  hi Title ctermfg=245 ctermbg=236 cterm=bold
  hi VertSplit ctermfg=244 ctermbg=236 cterm=NONE
  hi Visual ctermfg=NONE ctermbg=236 cterm=reverse
  hi VisualNOS ctermfg=NONE ctermbg=236 cterm=reverse
  hi WarningMsg ctermfg=201 ctermbg=236 cterm=bold
  hi WildMenu ctermfg=61 ctermbg=236 cterm=bold
  hi Comment ctermfg=244 ctermbg=NONE cterm=italic
  hi Constant ctermfg=61 ctermbg=NONE cterm=bold
  hi Number ctermfg=93 ctermbg=NONE cterm=bold
  hi Error ctermfg=201 ctermbg=236 cterm=bold,reverse
  hi Function ctermfg=208 ctermbg=NONE cterm=NONE
  hi Identifier ctermfg=208 ctermbg=NONE cterm=NONE
  hi Ignore ctermfg=187 ctermbg=NONE cterm=NONE
  hi PreProc ctermfg=161 ctermbg=NONE cterm=bold
  hi Include ctermfg=61 ctermbg=NONE cterm=bold
  hi Special ctermfg=208 ctermbg=NONE cterm=NONE
  hi Statement ctermfg=197 ctermbg=NONE cterm=bold
  hi Operator ctermfg=61 ctermbg=NONE cterm=NONE
  hi String ctermfg=220 ctermbg=NONE cterm=NONE
  hi Type ctermfg=161 ctermbg=NONE cterm=NONE
  hi Todo ctermfg=187 ctermbg=NONE cterm=bold,italic
  hi Underlined ctermfg=61 ctermbg=NONE cterm=NONE
  hi CursorIM ctermfg=NONE ctermbg=fg cterm=NONE
  hi ToolbarLine ctermfg=NONE ctermbg=236 cterm=NONE
  hi ToolbarButton ctermfg=187 ctermbg=236 cterm=bold
  if !s:italics
    hi FoldColumn cterm=NONE
    hi Folded cterm=NONE
    hi Comment cterm=NONE
    hi Todo cterm=bold
  endif
  unlet s:t_Co s:italics
  finish
endif

if s:t_Co >= 8
  if get(g:, 'cyberpunk_transp_bg', 0)
    hi Normal ctermfg=LightGrey ctermbg=NONE cterm=NONE
    hi Terminal ctermfg=LightGrey ctermbg=NONE cterm=NONE
  else
    hi Normal ctermfg=LightGrey ctermbg=NONE cterm=NONE
    hi Terminal ctermfg=LightGrey ctermbg=NONE cterm=NONE
  endif
  hi ColorColumn ctermfg=fg ctermbg=Black cterm=NONE
  hi Conceal ctermfg=DarkGrey ctermbg=NONE cterm=NONE
  hi Cursor ctermfg=NONE ctermbg=NONE cterm=reverse
  hi CursorColumn ctermfg=NONE ctermbg=Black cterm=NONE
  hi CursorLine ctermfg=NONE ctermbg=Black cterm=NONE
  hi CursorLineNr ctermfg=LightYellow ctermbg=Black cterm=NONE
  hi DiffAdd ctermfg=DarkGreen ctermbg=Black cterm=reverse
  hi DiffChange ctermfg=DarkBlue ctermbg=Black cterm=reverse
  hi DiffDelete ctermfg=DarkRed ctermbg=Black cterm=reverse
  hi DiffText ctermfg=DarkYellow ctermbg=Black cterm=bold,reverse
  hi Directory ctermfg=DarkGreen ctermbg=NONE cterm=bold
  hi EndOfBuffer ctermfg=LightGrey ctermbg=Black cterm=NONE
  hi ErrorMsg ctermfg=Black ctermbg=LightMagenta cterm=bold
  hi FoldColumn ctermfg=DarkGrey ctermbg=NONE cterm=italic
  hi Folded ctermfg=DarkGrey ctermbg=NONE cterm=italic
  hi IncSearch ctermfg=DarkYellow ctermbg=Black cterm=reverse
  hi LineNr ctermfg=DarkGreen ctermbg=NONE cterm=NONE
  hi MatchParen ctermfg=NONE ctermbg=Black cterm=bold
  hi ModeMsg ctermfg=LightYellow ctermbg=Black cterm=bold
  hi MoreMsg ctermfg=LightYellow ctermbg=Black cterm=bold
  hi NonText ctermfg=DarkGrey ctermbg=Black cterm=NONE
  hi Pmenu ctermfg=LightGrey ctermbg=Black cterm=NONE
  hi PmenuSbar ctermfg=NONE ctermbg=Black cterm=NONE
  hi PmenuSel ctermfg=Black ctermbg=DarkBlue cterm=bold
  hi PmenuThumb ctermfg=NONE ctermbg=Black cterm=NONE
  hi Question ctermfg=DarkYellow ctermbg=Black cterm=bold
  hi Search ctermfg=LightYellow ctermbg=Black cterm=reverse
  hi SignColumn ctermfg=NONE ctermbg=Black cterm=NONE
  hi SpecialKey ctermfg=Black ctermbg=NONE cterm=NONE
  hi SpellBad ctermfg=NONE ctermbg=NONE cterm=NONE
  hi SpellCap ctermfg=DarkGreen ctermbg=NONE cterm=NONE
  hi SpellLocal ctermfg=NONE ctermbg=NONE cterm=NONE
  hi SpellRare ctermfg=NONE ctermbg=NONE cterm=reverse
  hi StatusLine ctermfg=DarkGrey ctermbg=White cterm=NONE
  hi StatusLineNC ctermfg=Black ctermbg=LightGrey cterm=NONE
  hi TabLine ctermfg=LightGrey ctermbg=Black cterm=NONE
  hi TabLineFill ctermfg=DarkGrey ctermbg=Black cterm=NONE
  hi TabLineSel ctermfg=DarkGreen ctermbg=Black cterm=NONE
  hi Title ctermfg=DarkGreen ctermbg=Black cterm=bold
  hi VertSplit ctermfg=DarkGrey ctermbg=Black cterm=NONE
  hi Visual ctermfg=NONE ctermbg=Black cterm=reverse
  hi VisualNOS ctermfg=NONE ctermbg=Black cterm=reverse
  hi WarningMsg ctermfg=LightMagenta ctermbg=Black cterm=bold
  hi WildMenu ctermfg=DarkBlue ctermbg=Black cterm=bold
  hi Comment ctermfg=DarkGrey ctermbg=NONE cterm=italic
  hi Constant ctermfg=DarkBlue ctermbg=NONE cterm=bold
  hi Number ctermfg=LightBlue ctermbg=NONE cterm=bold
  hi Error ctermfg=LightMagenta ctermbg=Black cterm=bold,reverse
  hi Function ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi Identifier ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi Ignore ctermfg=LightGrey ctermbg=NONE cterm=NONE
  hi PreProc ctermfg=DarkRed ctermbg=NONE cterm=bold
  hi Include ctermfg=DarkBlue ctermbg=NONE cterm=bold
  hi Special ctermfg=DarkYellow ctermbg=NONE cterm=NONE
  hi Statement ctermfg=DarkMagenta ctermbg=NONE cterm=bold
  hi Operator ctermfg=DarkBlue ctermbg=NONE cterm=NONE
  hi String ctermfg=LightYellow ctermbg=NONE cterm=NONE
  hi Type ctermfg=DarkRed ctermbg=NONE cterm=NONE
  hi Todo ctermfg=LightGrey ctermbg=NONE cterm=bold,italic
  hi Underlined ctermfg=DarkBlue ctermbg=NONE cterm=NONE
  hi CursorIM ctermfg=NONE ctermbg=fg cterm=NONE
  hi ToolbarLine ctermfg=NONE ctermbg=Black cterm=NONE
  hi ToolbarButton ctermfg=LightGrey ctermbg=Black cterm=bold
  if !s:italics
    hi FoldColumn cterm=NONE
    hi Folded cterm=NONE
    hi Comment cterm=NONE
    hi Todo cterm=bold
  endif
  unlet s:t_Co s:italics
  finish
endif

if s:t_Co >= 2
  hi Normal term=NONE
  hi ColorColumn term=reverse
  hi Conceal term=NONE
  hi Cursor term=NONE
  hi CursorColumn term=reverse
  hi CursorLine term=underline
  hi CursorLineNr term=bold,italic,reverse,underline
  hi DiffAdd term=reverse,underline
  hi DiffChange term=reverse,underline
  hi DiffDelete term=reverse,underline
  hi DiffText term=bold,reverse,underline
  hi Directory term=NONE
  hi EndOfBuffer term=NONE
  hi ErrorMsg term=bold,italic,reverse
  hi FoldColumn term=reverse
  hi Folded term=italic,reverse,underline
  hi IncSearch term=bold,italic,reverse
  hi LineNr term=reverse
  hi MatchParen term=bold,underline
  hi ModeMsg term=NONE
  hi MoreMsg term=NONE
  hi NonText term=NONE
  hi Pmenu term=reverse
  hi PmenuSbar term=NONE
  hi PmenuSel term=NONE
  hi PmenuThumb term=NONE
  hi PopupSelected term=reverse
  hi Question term=standout
  hi Search term=italic,underline
  hi SignColumn term=reverse
  hi SpecialKey term=bold
  hi SpellBad term=italic,underline
  hi SpellCap term=italic,underline
  hi SpellLocal term=italic,underline
  hi SpellRare term=italic,underline
  hi StatusLine term=bold,reverse
  hi StatusLineNC term=reverse
  hi TabLine term=italic,reverse,underline
  hi TabLineFill term=reverse,underline
  hi TabLineSel term=bold
  hi Title term=bold
  hi VertSplit term=reverse
  hi Visual term=reverse
  hi VisualNOS term=NONE
  hi WarningMsg term=standout
  hi WildMenu term=bold
  hi Comment term=italic
  hi Constant term=bold,italic
  hi Error term=reverse
  hi Identifier term=italic
  hi Ignore term=NONE
  hi PreProc term=italic
  hi Special term=bold,italic
  hi Statement term=bold
  hi Todo term=bold,underline
  hi Type term=bold
  hi Underlined term=underline
  hi CursorIM term=NONE
  hi ToolbarLine term=reverse
  hi ToolbarButton term=bold,reverse
  if !s:italics
    hi CursorLineNr term=bold,reverse,underline
    hi ErrorMsg term=bold,reverse
    hi Folded term=reverse,underline
    hi IncSearch term=bold,reverse
    hi Search term=underline
    hi SpellBad term=underline
    hi SpellCap term=underline
    hi SpellLocal term=underline
    hi SpellRare term=underline
    hi TabLine term=reverse,underline
    hi Comment term=NONE
    hi Constant term=bold
    hi Identifier term=NONE
    hi PreProc term=NONE
    hi Special term=bold
  endif
  unlet s:t_Co s:italics
  finish
endif

" Background: dark
" Color: black         #312e39                   ~         Black
" Color: magenta1      #c72e68                   ~    DarkRed
" Color: brown1         #978979                   ~         DarkGreen
" Color: orange        #f28920                   ~         DarkYellow
" Color: blue1         #342d59                   ~         DarkBlue
" Color: blue2         #3e518e                   ~         DarkCyan
" Color: blue3         #6262ae                   ~         DarkBlue
" Color: blue4         #871ff5                   ~         LightBlue
" Color: magenta2      #ff2975                   ~        DarkMagenta
" Color: white         #ebdbb2                   ~         LightGrey
" Color: darkbrown   #8a7c6f                   ~         DarkGrey
" Color: brown2   #afa38b                   ~         LightGreen
" Color: yellow  #f8cd1a                   ~         LightYellow
" Color: magenta3 #f022fd                   ~         LightMagenta
" Color: skincolor   #f9c2a0                   ~         White
" Term colors: black magenta1 brown1 orange blue2 magenta2 magenta3 white
" Term colors: darkbrown magenta2 brown2 yellow
" Term colors: blue3 magenta3 blue2 skincolor
" vim: et ts=2 sw=2
