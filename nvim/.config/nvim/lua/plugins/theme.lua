-- lua/plugins/theme.lua
require("kanagawa").setup({
	compile = false,
	undercurl = false,
	commentStyle = { italic = false },
	functionStyle = {},
	keywordStyle = { italic = false },
	statementStyle = { bold = true },
	typeStyle = { italic = false },
	transparent = true,
	dimInactive = false,
	terminalColors = true,
	colors = {
		palette = {},
		theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
	},
	theme = "wave",
	background = {
		dark = "wave",
		light = "lotus",
	},
	overrides = function(colors)
		local pallette = colors.palette
		local theme = colors.theme

		return {
			StatusLineNC = { fg = pallette.fujiWhite, bg = pallette.sumiInk0 },
			StatusLine = { fg = pallette.fujiWhite, bg = pallette.sumiInk4 },
			StatusLineErrSign = { fg = theme.diag.error, bg = pallette.sumiInk4 },
			StatusLineWarnSign = { fg = theme.diag.warning, bg = pallette.sumiInk4 },
			StatusLineHintSign = { fg = theme.diag.hint, bg = pallette.sumiInk4 },
			StatusLineInfoSign = { fg = theme.diag.info, bg = pallette.sumiInk4 },
			CursorLineNr = { fg = pallette.roninYellow, bg = pallette.sumiInk5 },
			ColorColumn = { bg = pallette.sumiInk4 },
			SignColumn = { bg = "None" },
			LineNr = { fg = pallette.sumiInk6, bg = "None" },
			TroubleLspFileName = { bg = "None", fg = pallette.fujiWhite },
			TroubleNormal = { bg = "None" },
			TroubleNormalNC = { bg = "None" },
			NormalFloat = { bg = "none" },
			FloatBorder = { bg = "none" },
			FloatTitle = { bg = "none" },
			NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
			LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
			["@variable.builtin.php"] = { italic = false, fg = pallette.waveRed, bg = "none" },
			CodeActionVirtText = { fg = theme.diag.hint, bg = pallette.sumiInk5 },
		}
	end,
})

vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅙", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀦", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌵", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo", { texthl = "DiagnosticSignInfo", text = "󰀨", numhl = "" })

vim.opt.fillchars = "eob: ,vert: "

vim.cmd([[
    set termguicolors
    set noshowmode
    call matchadd('ColorColumn', '\%82v', 100)
    set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
    augroup CursorLine
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
    augroup END
]])

vim.cmd("colorscheme kanagawa")
