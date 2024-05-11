vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅙", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀦", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌵", numhl = "" })
vim.fn.sign_define("DiagnosticSignInformation", {
	texthl = "DiagnosticSignInformation",
	text = "󰀨",
	numhl = "",
})

vim.cmd("colorscheme xresources")

vim.opt.fillchars = "eob: ,vert: "

local function modify_hl(ns, name, changes)
	local def = vim.api.nvim_get_hl(ns, { name = name, link = false })
	vim.api.nvim_set_hl(ns, name, vim.tbl_deep_extend("force", def, changes))
end

vim.cmd([[
	" autocmd Vimenter * hi Normal guibg=NONE ctermbg=NONE
    set termguicolors
    " set cursorline
    set noshowmode

    call matchadd('ColorColumn', '\%82v', 100)

    set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow

    augroup CursorLine
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
    augroup END
]])

local color = require("xresources")

modify_hl(0, "Normal", { bg = color.none, ctermbg = color.none })
modify_hl(0, "NonText", { bg = color.none, ctermbg = color.none })
modify_hl(0, "InactiveWindow", { bg = color.none, ctermbg = color.none })
modify_hl(0, "ActiveWindow", { bg = color.none, ctermbg = color.none })
modify_hl(0, "SignColumn", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsAdd", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitGutterAdd", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsChange", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitGutterChange", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsDelete", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitGutterDelete", { bg = color.none, ctermbg = color.none })
modify_hl(0, "DiffAdd", { bg = color.none, ctermbg = color.none })
modify_hl(0, "DiffChange", { bg = color.none, ctermbg = color.none })
modify_hl(0, "DiffDelete", { bg = color.none, ctermbg = color.none })
modify_hl(0, "DiffText", { bg = color.none, ctermbg = color.none })
modify_hl(0, "Keyword", { fg = color.purple, bold = false })
modify_hl(0, "Function", { bold = false })
modify_hl(0, "TSVariable", { fg = color.red })
modify_hl(0, "TSProperty", { fg = color.fg })
modify_hl(0, "TSAttribute", { fg = color.yellow })
modify_hl(0, "TSConstant", { fg = color.yellow })
modify_hl(0, "StatusLineNC", { fg = color.fg, bg = color.light_black })
modify_hl(0, "StatusLine", { fg = color.fg, bg = color.bg, bold = true })
modify_hl(0, "StatusLineErrSign", { fg = color.red, bg = color.bg })
modify_hl(0, "StatusLineWarnSign", { fg = color.yellow, bg = color.bg })
modify_hl(0, "StatusLineHintSign", { fg = color.cyan, bg = color.bg })
modify_hl(0, "StatusLineInfoSign", { fg = color.blue, bg = color.bg })
modify_hl(0, "DiagnosticError", { fg = color.red, bg = color.grey })
modify_hl(0, "DiagnosticSignError", { fg = color.red, bg = color.none })
modify_hl(0, "DiagnosticHint", { fg = color.magenta })
modify_hl(0, "DiagnosticSignHint", { fg = color.magenta })
modify_hl(0, "DiagnosticInfo", { fg = color.blue, bg = color.grey })
modify_hl(0, "DiagnosticSignInfo", { fg = color.blue, bg = color.none })
modify_hl(0, "DiagnosticWarn", { fg = color.yellow, bg = color.grey })
modify_hl(0, "DiagnosticSignWarn", { fg = color.yellow, bg = color.none })
modify_hl(0, "GitSignsAdd", { fg = color.green })
modify_hl(0, "GitSignsChange", { fg = color.blue })
modify_hl(0, "GitSignsDelete", { fg = color.red })
modify_hl(0, "LineNr", { fg = color.fg, bg = color.none })
modify_hl(0, "VertSplit", { fg = color.none, bg = color.none })
modify_hl(0, "CursorLineNr", { fg = color.yellow, bg = color.none, bold = true })
modify_hl(0, "ColorColumn", { fg = color.black, bg = color.purple })
modify_hl(0, "@tag.twig", { fg = color.blue })
modify_hl(0, "@tag.html", { fg = color.cyan })
modify_hl(0, "@tag.attribute.html", { fg = color.blue })
modify_hl(0, "@attribute.phpdoc", { fg = color.yellow })
modify_hl(0, "@attribute.php", { fg = color.yellow })

modify_hl(0, "CmpItemAbbrDeprecated", { bg = color.none, strikethrough = true })
modify_hl(0, "CmpItemAbbrMatch", { fg = color.blue, bg = color.none })
modify_hl(0, "CmpItemAbbrMatchFuzzy", { fg = color.blue, bg = color.none })
modify_hl(0, "CmpItemKindVariable", { fg = color.light_blue, bg = color.none })
modify_hl(0, "CmpItemKindInterface", { fg = color.light_blue, bg = color.none })
modify_hl(0, "CmpItemKindText", { fg = color.light_blue, bg = color.none })
modify_hl(0, "CmpItemKindFunction", { fg = color.pink, bg = color.none })
modify_hl(0, "CmpItemKindMethod", { fg = color.pink, bg = color.none })
modify_hl(0, "CmpItemKindKeyword", { fg = color.red, bg = color.none })
