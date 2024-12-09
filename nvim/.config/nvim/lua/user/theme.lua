vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅙", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀦", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌵", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo", {
	texthl = "DiagnosticSignInfo",
	text = "󰀨",
	numhl = "",
})

vim.cmd("colorscheme xresources")

vim.opt.fillchars = "eob: ,vert: "

local function modify_hl(ns, name, changes)
	local def = vim.api.nvim_get_hl(ns, { name = name, link = false })
	vim.api.nvim_set_hl(ns, name, vim.tbl_deep_extend("force", def, changes))
end

local function link(ns, source, target)
	vim.api.nvim_set_hl(ns, source, { link = target })
end

local function get_lighter_color(before_color, hex)
	local t = tostring(before_color)
	local s = string.sub(t, 2, 7)
	local after_color = tonumber("0x" .. s) + hex
	local final_color = "#" .. string.format("%x", after_color)
	return final_color
end

local function get_darker_color(before_color, hex)
	local t = tostring(before_color)
	local s = string.sub(t, 2, 7)
	local after_color = tonumber("0x" .. s) - hex
	local final_color = "#" .. string.format("%x", after_color)
	return final_color
end

local function clamp(component)
	return math.min(math.max(component, 0), 255)
end

local function lighten_darken_color(col, amt)
	local num = tonumber(col:sub(2), 16)
	local r = math.floor(num / 0x10000) + amt
	local g = (math.floor(num / 0x100) % 0x100) + amt
	local b = (num % 0x100) + amt
	local result = "#" .. string.format("%X", clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b))
	return result
end

local function color_to_hex(col)
	return tonumber(col:sub(2), 16)
end

local function get_r_from_rgb(col)
	local r = math.floor(col / 0x10000)
	return r
end

local function get_g_from_rgb(col)
	local g = (math.floor(col / 0x100) % 0x100)
	return g
end

local function get_b_from_rgb(col)
	local b = col % 0x100
	return b
end

local function pseudo_transparent(color, background, foreground_alpha, background_alpha)
	if foreground_alpha == nil then
		foreground_alpha = 0.5
	end

	if background_alpha == nil then
		background_alpha = 1
	end

	local col = color_to_hex(color)
	local bg = color_to_hex(background)

	-- local r = get_r_from_rgb(col) * foreground_alpha + get_r_from_rgb(bg) * background_alpha * (1 - foreground_alpha)
	-- local g = get_g_from_rgb(col) * foreground_alpha + get_g_from_rgb(bg) * background_alpha * (1 - foreground_alpha)
	-- local b = get_b_from_rgb(col) * foreground_alpha + get_b_from_rgb(bg) * background_alpha * (1 - foreground_alpha)
	--
	local r = get_r_from_rgb(bg) * (1 - foreground_alpha) + (get_r_from_rgb(col) * foreground_alpha)
	local g = get_g_from_rgb(bg) * (1 - foreground_alpha) + (get_g_from_rgb(col) * foreground_alpha)
	local b = get_b_from_rgb(bg) * (1 - foreground_alpha) + (get_b_from_rgb(col) * foreground_alpha)

	return "#" .. string.format("%X", clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b))
end

local function mix_colors(_col1, _col2, factor)
	if factor == nil then
		factor = 0.5
	end

	local col1 = color_to_hex(_col1)
	local col2 = color_to_hex(_col2)

	local r1 = get_r_from_rgb(col1)
	local g1 = get_g_from_rgb(col1)
	local b1 = get_b_from_rgb(col1)

	local r2 = get_r_from_rgb(col2)
	local g2 = get_g_from_rgb(col2)
	local b2 = get_b_from_rgb(col2)

	local r = r1 * (1 - factor) + r2 * factor
	local g = g1 * (1 - factor) + g2 * factor
	local b = b1 * (1 - factor) + b2 * factor

	local result = "#" .. string.format("%X", clamp(r) * 0x10000 + clamp(g) * 0x100 + clamp(b))
	return result
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

-- vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = color.grey })
-- vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = color.blue })
-- vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })
-- vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = color.light_blue })
-- vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })
-- vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })
-- vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = color.pink })
-- vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })
-- vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = color.fg })
-- vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })
-- vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })
-- local statusLineBg = "#191724"
local statusLineBg = color.grey

local diff_hl = {
	-- add = {
	-- 	bg = vim.o.background == "light" and get_darker_color(color.green, 0xf0f10)
	-- 		or get_lighter_color(color.green, 0xf0f10),
	-- },
	-- change = {
	-- 	bg = vim.o.background == "light" and get_darker_color(color.blue, 0xf0f10)
	-- 		or get_lighter_color(color.blu, 0xf0f10),
	-- },
	-- delete = {
	-- 	bg = vim.o.background == "light" and get_darker_color(color.red, 0xf0f10)
	-- 		or get_lighter_color(color.red, 0xf0f10),
	-- },
	-- text = { fg = color.fg, bg = color.none },
	-- add_as_delete = {
	-- 	bg = vim.o.background == "light" and get_darker_color(color.purple, 0xf0f10)
	-- 		or get_lighter_color(color.purple, 0xf0f10),
	-- },
	-- delete_dim = {
	-- 	bg = vim.o.background == "light" and get_darker_color(color.yellow, 0xf0f10)
	-- 		or get_lighter_color(color.yellow, 0xf0f10),
	-- },
	add = {
		fg = color.green,
		bg = color.bg,
	},
	change = {
		fg = color.blue,
		bg = color.bg,
	},
	delete = {
		fg = color.red,
		bg = color.bg,
	},
	-- add = {
	-- 	bg = mix_colors(color.green, color.bg, 0.95),
	-- },
	-- change = {
	-- 	bg = mix_colors(color.blue, color.bg, 0.95),
	-- },
	-- delete = {
	-- 	bg = mix_colors(color.red, color.bg, 0.95),
	-- },
	text = { fg = color.fg, bg = color.none },
	add_as_delete = {
		bg = "magenta",
	},
	delete_dim = {
		bg = "yellow",
	},
}

modify_hl(0, "Normal", { bg = color.none, ctermbg = color.none })
modify_hl(0, "Added", { fg = color.green })
modify_hl(0, "Removed", { fg = color.red })
modify_hl(0, "Changed", { fg = color.cyan })
modify_hl(0, "Comment", { bg = color.none, fg = color.light_white })
modify_hl(0, "NormalFloat", { bg = color.none, ctermbg = color.none })
modify_hl(0, "NonText", { bg = color.none, ctermbg = color.none })
modify_hl(0, "InactiveWindow", { bg = color.none, ctermbg = color.none })
modify_hl(0, "ActiveWindow", { bg = color.none, ctermbg = color.none })
modify_hl(0, "SignColumn", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsAdd", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsStagedAdd", { bg = color.none, ctermbg = color.none, fg = color.green })
modify_hl(0, "GitGutterAdd", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsChange", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsStagedChange", { bg = color.none, ctermbg = color.none, fg = color.blue })
modify_hl(0, "GitGutterChange", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsDelete", { bg = color.none, ctermbg = color.none })
modify_hl(0, "GitSignsStagedDelete", { bg = color.none, ctermbg = color.none, fg = color.red })
modify_hl(0, "GitGutterDelete", { bg = color.none, ctermbg = color.none })
modify_hl(0, "DiffAdd", { bg = color.none, ctermbg = color.none })
modify_hl(0, "DiffChange", { bg = color.none, ctermbg = color.none })
modify_hl(0, "DiffDelete", { bg = color.none, ctermbg = color.none })
modify_hl(0, "DiffText", { bg = color.none, ctermbg = color.none })
modify_hl(0, "Keyword", { fg = color.purple, bold = true })
modify_hl(0, "Function", { bold = true })
modify_hl(0, "TSVariable", { fg = color.red })
modify_hl(0, "TSProperty", { fg = color.fg })
modify_hl(0, "TSAttribute", { fg = color.yellow })
modify_hl(0, "TSConstant", { fg = color.yellow })
modify_hl(0, "StatusLineNC", { fg = color.fg, bg = color.light_black })
modify_hl(0, "StatusLine", { fg = color.fg, bg = statusLineBg, bold = true })
modify_hl(0, "StatusLineErrSign", { fg = color.red, bg = statusLineBg })
modify_hl(0, "StatusLineWarnSign", { fg = color.yellow, bg = statusLineBg })
modify_hl(0, "StatusLineHintSign", { fg = color.blue, bg = statusLineBg })
modify_hl(0, "StatusLineInfoSign", { fg = color.cyan, bg = statusLineBg })
modify_hl(0, "DiagnosticError", { fg = color.red, bg = color.none })
modify_hl(0, "DiagnosticSignError", { fg = color.red, bg = color.none })
modify_hl(0, "DiagnosticHint", { fg = color.blue })
modify_hl(0, "DiagnosticSignHint", { fg = color.blue })
modify_hl(0, "DiagnosticInfo", { fg = color.cyan, bg = color.grey })
modify_hl(0, "DiagnosticSignInfo", { fg = color.cyan, bg = color.none })
modify_hl(0, "DiagnosticWarn", { fg = color.yellow, bg = color.grey })
modify_hl(0, "DiagnosticSignWarn", { fg = color.yellow, bg = color.none })
modify_hl(0, "DiagnosticUnnecessary", { fg = color.light_white, bg = color.none })
modify_hl(0, "GitSignsAdd", { fg = color.green })
modify_hl(0, "GitSignsChange", { fg = color.blue })
modify_hl(0, "GitSignsDelete", { fg = color.red })
modify_hl(0, "LineNr", { fg = color.fg, bg = color.none })
modify_hl(0, "VertSplit", { fg = color.none, bg = color.none })
modify_hl(0, "CursorLineNr", { fg = color.yellow, bg = color.none, bold = false })
modify_hl(0, "ColorColumn", { fg = color.black, bg = color.purple })
modify_hl(0, "@tag.twig", { fg = color.blue })
modify_hl(0, "@tag.html", { fg = color.cyan })
modify_hl(0, "@tag.attribute.html", { fg = color.blue })
modify_hl(0, "@attribute.phpdoc", { fg = color.yellow })
modify_hl(0, "@attribute.php", { fg = color.yellow })
modify_hl(0, "@variable", { fg = color.red })

modify_hl(0, "CmpItemAbbrDeprecated", { bg = color.none, strikethrough = true })
modify_hl(0, "CmpItemAbbrMatch", { fg = color.blue, bg = color.none })
modify_hl(0, "CmpItemAbbrMatchFuzzy", { fg = color.blue, bg = color.none })
modify_hl(0, "CmpItemKindVariable", { fg = color.light_blue, bg = color.none })
modify_hl(0, "CmpItemKindInterface", { fg = color.light_blue, bg = color.none })
modify_hl(0, "CmpItemKindText", { fg = color.light_blue, bg = color.none })
modify_hl(0, "CmpItemKindFunction", { fg = color.pink, bg = color.none })
modify_hl(0, "CmpItemKindMethod", { fg = color.pink, bg = color.none })
modify_hl(0, "CmpItemKindKeyword", { fg = color.red, bg = color.none })

modify_hl(0, "DiffViewDiffAdd", diff_hl.add)
modify_hl(0, "DiffViewDiffDelete", diff_hl.delete)
modify_hl(0, "DiffViewDiffChange", diff_hl.change)
modify_hl(0, "DiffViewDiffText", diff_hl.text)
modify_hl(0, "DiffViewDiffAddAsDelete", diff_hl.add_as_delete)
modify_hl(0, "DiffViewDiffDeleteDim", diff_hl.delete_dim)
modify_hl(0, "DiffviewFolderName", { fg = color.fg })
modify_hl(0, "DiffviewFilePanelFileName", { fg = color.fg })

modify_hl(0, "NeotestDir", { bg = color.none, fg = color.fg })
modify_hl(0, "NeotestFile", { bg = color.none, fg = color.fg })
modify_hl(0, "NeotestNamespace", { bg = color.none, fg = color.fg })
modify_hl(0, "NeotestTest", { bg = color.none, fg = color.fg })
modify_hl(0, "NeotestRunning", { bg = color.none, fg = color.yellow })
modify_hl(0, "NeotestPassed", { bg = color.none, fg = color.green })
modify_hl(0, "NeotestFailed", { bg = color.none, fg = color.red })
modify_hl(0, "NeotestAdapterName", { bg = color.none, fg = color.light_red })

modify_hl(0, "OilDir", { bg = color.none, fg = color.fg, bold = true })

modify_hl(0, "DiffAdd", diff_hl.add)
modify_hl(0, "DiffChange", diff_hl.change)
modify_hl(0, "DiffDelete", diff_hl.delete)
modify_hl(0, "DiffText", diff_hl.text)

link(0, "@diff.add", "DiffAdd")
link(0, "@diff.minus", "DiffDelete")
link(0, "@diff.delta", "DiffChange")

modify_hl(0, "diffAdded", diff_hl.add)
modify_hl(0, "diffRemoved", diff_hl.delete)
modify_hl(0, "diffChanged", diff_hl.change)
modify_hl(0, "diffOldFile", { fg = color.yellow })
modify_hl(0, "diffNewFile", { fg = "orange" })
modify_hl(0, "diffFile", { fg = color.blue })
modify_hl(0, "diffLine", { fg = color.grey })
modify_hl(0, "diffIndexLine", { fg = color.purple })

modify_hl(0, "NormalFloat", { bg = color.none })

modify_hl(0, "Directory", { bg = color.none, fg = color.fg })
modify_hl(0, "TroubleLspFileName", { bg = color.none, fg = color.fg })
modify_hl(0, "TroubleNormal", { bg = color.none })
modify_hl(0, "TroubleNormalNC", { bg = color.none })
modify_hl(0, "DiagnosticUnderlineInfo", { underline = false })

modify_hl(0, "LspInlayHint", { bg = color.none, fg = color.light_white })

modify_hl(0, "@type.builtin.c", { bg = color.none, fg = color.yellow })
