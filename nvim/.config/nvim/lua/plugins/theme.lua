-- return {
-- 	-- "nekonako/xresources-nvim",
-- 	"rose-pine/neovim",
-- 	config = function()
-- 		require("rose-pine").setup({
-- 			variant = "auto",
-- 			dark_variant = "moon",
-- 			dim_inactive_windows = false,
--
-- 			styles = {
-- 				italic = false,
-- 			},
--
-- 			highlight_groups = {
-- 				["@tag.twig"] = { fg = "pine" },
-- 				["@tag.html"] = { fg = "foam" },
-- 				["@tag.attribute.html"] = { fg = "pine" },
-- 				["@attribute.phpdoc"] = { fg = "gold" },
-- 				["@attribute.php"] = { fg = "rose" },
-- 				["@property"] = { fg = "rose" },
-- 				["@variable"] = { fg = "rose" },
-- 				["@variable.member"] = { fg = "rose" },
-- 				["@variable.parameter"] = { fg = "pine" },
-- 				["@module.php"] = { fg = "rose" },
-- 				["@type.builtin"] = { fg = "love" },
-- 				["@type"] = { fg = "love" },
-- 				["@keyword.import"] = { fg = "iris" },
-- 				["@keyword.modifier.php"] = { fg = "pine" },
-- 				["@keyword.function.php"] = { fg = "pine" },
-- 				["@function"] = { fg = "pine" },
-- 				["@function.method"] = { fg = "iris" },
-- 				Number = { fg = "rose" },
-- 				Keyword = { fg = "iris" },
-- 				StatusLineNC = { fg = "text", bg = "subtle" },
-- 				StatusLine = { fg = "text", bg = "surface" },
-- 				StatusLineErrSign = { fg = "love", bg = "surface" },
-- 				StatusLineWarnSign = { fg = "rose", bg = "surface" },
-- 				StatusLineHintSign = { fg = "foam", bg = "surface" },
-- 				StatusLineInfoSign = { fg = "pine", bg = "surface" },
-- 			},
-- 		})
--
-- 		-- modify_hl(0, "GitSignsAdd", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsStagedAdd", { bg = color.none, ctermbg = color.none, fg = color.green })
-- 		-- modify_hl(0, "GitGutterAdd", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsChange", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsStagedChange", { bg = color.none, ctermbg = color.none, fg = color.blue })
-- 		-- modify_hl(0, "GitGutterChange", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsDelete", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsStagedDelete", { bg = color.none, ctermbg = color.none, fg = color.red })
-- 		-- modify_hl(0, "GitGutterDelete", { bg = color.none, ctermbg = color.none })
--
-- 		vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅙", numhl = "" })
-- 		vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀦", numhl = "" })
-- 		vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌵", numhl = "" })
-- 		vim.fn.sign_define("DiagnosticSignInfo", {
-- 			texthl = "DiagnosticSignInfo",
-- 			text = "󰀨",
-- 			numhl = "",
-- 		})
--
-- 		-- vim.cmd("colorscheme xresources")
-- 		-- vim.cmd("colorscheme gruvbox")
-- 		vim.cmd("colorscheme rose-pine-moon")
--
-- 		vim.opt.fillchars = "eob: ,vert: "
--
-- 		local function modify_hl(ns, name, changes)
-- 			local def = vim.api.nvim_get_hl(ns, { name = name, link = false })
-- 			vim.api.nvim_set_hl(ns, name, vim.tbl_deep_extend("force", def, changes))
-- 		end
--
-- 		local function link(ns, source, target)
-- 			vim.api.nvim_set_hl(ns, source, { link = target })
-- 		end
--
-- 		vim.cmd([[
--             " autocmd Vimenter * hi Normal guibg=NONE ctermbg=NONE
--             set termguicolors
--             " set cursorline
--             set noshowmode
--
--             call matchadd('ColorColumn', '\%82v', 100)
--
--             set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
--
--             augroup CursorLine
--                 au!
--                 au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
--                 au WinLeave * setlocal nocursorline
--             augroup END
--         ]])
--
-- 		-- -- local color = require("xresources")
-- 		--
-- 		-- local statusLineBg = color.grey
-- 		--
-- 		-- local diff_hl = {
-- 		-- 	add = {
-- 		-- 		fg = color.green,
-- 		-- 		bg = color.bg,
-- 		-- 	},
-- 		-- 	change = {
-- 		-- 		fg = color.blue,
-- 		-- 		bg = color.bg,
-- 		-- 	},
-- 		-- 	delete = {
-- 		-- 		fg = color.red,
-- 		-- 		bg = color.bg,
-- 		-- 	},
-- 		-- 	text = { fg = color.fg, bg = color.none },
-- 		-- 	add_as_delete = {
-- 		-- 		bg = "magenta",
-- 		-- 	},
-- 		-- 	delete_dim = {
-- 		-- 		bg = "yellow",
-- 		-- 	},
-- 		-- }
-- 		--
-- 		-- modify_hl(0, "Normal", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "Added", { fg = color.green })
-- 		-- modify_hl(0, "Removed", { fg = color.red })
-- 		-- modify_hl(0, "Changed", { fg = color.cyan })
-- 		-- modify_hl(0, "Comment", { bg = color.none, fg = color.light_white })
-- 		-- modify_hl(0, "FloatBorder", { fg = color.light_white, bg = color.none })
-- 		-- modify_hl(0, "NormalFloat", { bg = color.none, ctermbg = color.none, fg = color.white })
-- 		-- modify_hl(0, "NonText", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "InactiveWindow", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "ActiveWindow", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "SignColumn", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsAdd", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsStagedAdd", { bg = color.none, ctermbg = color.none, fg = color.green })
-- 		-- modify_hl(0, "GitGutterAdd", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsChange", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsStagedChange", { bg = color.none, ctermbg = color.none, fg = color.blue })
-- 		-- modify_hl(0, "GitGutterChange", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsDelete", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "GitSignsStagedDelete", { bg = color.none, ctermbg = color.none, fg = color.red })
-- 		-- modify_hl(0, "GitGutterDelete", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "DiffAdd", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "DiffChange", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "DiffDelete", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "DiffText", { bg = color.none, ctermbg = color.none })
-- 		-- modify_hl(0, "Keyword", { fg = color.purple, bold = true })
-- 		-- modify_hl(0, "Function", { bold = true })
-- 		-- modify_hl(0, "TSVariable", { fg = color.red })
-- 		-- modify_hl(0, "TSProperty", { fg = color.fg })
-- 		-- modify_hl(0, "TSAttribute", { fg = color.yellow })
-- 		-- modify_hl(0, "TSConstant", { fg = color.yellow })
-- 		-- modify_hl(0, "StatusLineNC", { fg = color.fg, bg = color.light_black })
-- 		-- modify_hl(0, "StatusLine", { fg = color.fg, bg = statusLineBg, bold = true })
-- 		-- modify_hl(0, "StatusLineErrSign", { fg = color.red, bg = statusLineBg })
-- 		-- modify_hl(0, "StatusLineWarnSign", { fg = color.yellow, bg = statusLineBg })
-- 		-- modify_hl(0, "StatusLineHintSign", { fg = color.blue, bg = statusLineBg })
-- 		-- modify_hl(0, "StatusLineInfoSign", { fg = color.cyan, bg = statusLineBg })
-- 		-- modify_hl(0, "DiagnosticError", { fg = color.red, bg = color.none })
-- 		-- modify_hl(0, "DiagnosticSignError", { fg = color.red, bg = color.none })
-- 		-- modify_hl(0, "DiagnosticHint", { fg = color.blue, bg = color.none })
-- 		-- modify_hl(0, "DiagnosticSignHint", { fg = color.blue, bg = color.none })
-- 		-- modify_hl(0, "DiagnosticInfo", { fg = color.cyan, bg = color.none })
-- 		-- modify_hl(0, "DiagnosticSignInfo", { fg = color.cyan, bg = color.none })
-- 		-- modify_hl(0, "DiagnosticWarn", { fg = color.yellow, bg = color.grey })
-- 		-- modify_hl(0, "DiagnosticSignWarn", { fg = color.yellow, bg = color.none })
-- 		-- modify_hl(0, "DiagnosticUnnecessary", { fg = color.light_white, bg = color.none })
-- 		-- modify_hl(0, "GitSignsAdd", { fg = color.green })
-- 		-- modify_hl(0, "GitSignsChange", { fg = color.blue })
-- 		-- modify_hl(0, "GitSignsDelete", { fg = color.red })
-- 		-- modify_hl(0, "LineNr", { fg = color.fg, bg = color.none })
-- 		-- modify_hl(0, "VertSplit", { fg = color.none, bg = color.none })
-- 		-- modify_hl(0, "CursorLineNr", { fg = color.yellow, bg = color.none, bold = false })
-- 		-- modify_hl(0, "ColorColumn", { fg = color.black, bg = color.purple })
-- 		-- modify_hl(0, "@tag.twig", { fg = color.blue })
-- 		-- modify_hl(0, "@tag.html", { fg = color.cyan })
-- 		-- modify_hl(0, "@tag.attribute.html", { fg = color.blue })
-- 		-- modify_hl(0, "@attribute.phpdoc", { fg = color.yellow })
-- 		-- modify_hl(0, "@attribute.php", { fg = color.yellow })
-- 		-- modify_hl(0, "@variable", { fg = color.red })
-- 		--
-- 		-- modify_hl(0, "CmpItemAbbrDeprecated", { bg = color.none, strikethrough = true })
-- 		-- modify_hl(0, "CmpItemAbbrMatch", { fg = color.blue, bg = color.none })
-- 		-- modify_hl(0, "CmpItemAbbrMatchFuzzy", { fg = color.blue, bg = color.none })
-- 		-- modify_hl(0, "CmpItemKindVariable", { fg = color.light_blue, bg = color.none })
-- 		-- modify_hl(0, "CmpItemKindInterface", { fg = color.light_blue, bg = color.none })
-- 		-- modify_hl(0, "CmpItemKindText", { fg = color.light_blue, bg = color.none })
-- 		-- modify_hl(0, "CmpItemKindFunction", { fg = color.pink, bg = color.none })
-- 		-- modify_hl(0, "CmpItemKindMethod", { fg = color.pink, bg = color.none })
-- 		-- modify_hl(0, "CmpItemKindKeyword", { fg = color.red, bg = color.none })
-- 		--
-- 		-- modify_hl(0, "DiffViewDiffAdd", diff_hl.add)
-- 		-- modify_hl(0, "DiffViewDiffDelete", diff_hl.delete)
-- 		-- modify_hl(0, "DiffViewDiffChange", diff_hl.change)
-- 		-- modify_hl(0, "DiffViewDiffText", diff_hl.text)
-- 		-- modify_hl(0, "DiffViewDiffAddAsDelete", diff_hl.add_as_delete)
-- 		-- modify_hl(0, "DiffViewDiffDeleteDim", diff_hl.delete_dim)
-- 		-- modify_hl(0, "DiffviewFolderName", { fg = color.fg })
-- 		-- modify_hl(0, "DiffviewFilePanelFileName", { fg = color.fg })
-- 		--
-- 		-- modify_hl(0, "NeotestDir", { bg = color.none, fg = color.fg })
-- 		-- modify_hl(0, "NeotestFile", { bg = color.none, fg = color.fg })
-- 		-- modify_hl(0, "NeotestNamespace", { bg = color.none, fg = color.fg })
-- 		-- modify_hl(0, "NeotestTest", { bg = color.none, fg = color.fg })
-- 		-- modify_hl(0, "NeotestRunning", { bg = color.none, fg = color.yellow })
-- 		-- modify_hl(0, "NeotestPassed", { bg = color.none, fg = color.green })
-- 		-- modify_hl(0, "NeotestFailed", { bg = color.none, fg = color.red })
-- 		-- modify_hl(0, "NeotestAdapterName", { bg = color.none, fg = color.light_red })
-- 		--
-- 		-- modify_hl(0, "BlinkCmpMenuBorder", { bg = color.none, fg = color.white })
-- 		-- modify_hl(0, "BlinkCmpMenuSelection", { bg = color.black, fg = color.fg })
-- 		-- modify_hl(0, "PmenuSbar", { fg = color.none, bg = color.none })
-- 		-- modify_hl(0, "PmenuThumb", { fg = color.none, bg = color.none })
-- 		-- modify_hl(0, "BlinkCmpLabel", { bg = color.none })
-- 		-- modify_hl(0, "BlinkCmpMenu", { bg = color.none })
-- 		-- modify_hl(0, "Pmenu", { bg = color.none })
-- 		-- modify_hl(0, "BlinkCmpKind", { fg = color.red })
-- 		-- modify_hl(0, "BlinkCmpSignatureHelp", { bg = color.none, fg = color.white })
-- 		-- modify_hl(0, "BlinkCmpSignatureHelpBorder", { bg = color.none, fg = color.red })
-- 		-- modify_hl(0, "BlinkCmpSignatureHelpActiveParameter", { bg = color.none, fg = color.red })
-- 		--
-- 		-- modify_hl(0, "OilDir", { bg = color.none, fg = color.fg, bold = true })
--
-- 		-- modify_hl(0, "DiffAdd", diff_hl.add)
-- 		-- modify_hl(0, "DiffChange", diff_hl.change)
-- 		-- modify_hl(0, "DiffDelete", diff_hl.delete)
-- 		-- modify_hl(0, "DiffText", diff_hl.text)
-- 		--
-- 		-- link(0, "@diff.add", "DiffAdd")
-- 		-- link(0, "@diff.minus", "DiffDelete")
-- 		-- link(0, "@diff.delta", "DiffChange")
-- 		--
-- 		-- modify_hl(0, "diffAdded", diff_hl.add)
-- 		-- modify_hl(0, "diffRemoved", diff_hl.delete)
-- 		-- modify_hl(0, "diffChanged", diff_hl.change)
-- 		-- modify_hl(0, "diffOldFile", { fg = color.yellow })
-- 		-- modify_hl(0, "diffNewFile", { fg = "orange" })
-- 		-- modify_hl(0, "diffFile", { fg = color.blue })
-- 		-- modify_hl(0, "diffLine", { fg = color.grey })
-- 		-- modify_hl(0, "diffIndexLine", { fg = color.purple })
-- 		--
-- 		-- modify_hl(0, "Directory", { bg = color.none, fg = color.fg })
-- 		-- modify_hl(0, "TroubleLspFileName", { bg = color.none, fg = color.fg })
-- 		-- modify_hl(0, "TroubleNormal", { bg = color.none })
-- 		-- modify_hl(0, "TroubleNormalNC", { bg = color.none })
-- 		modify_hl(0, "DiagnosticUnderlineInfo", { underline = false })
--
-- 		-- modify_hl(0, "LspInlayHint", { bg = color.none, fg = color.light_white })
-- 		--
-- 		-- modify_hl(0, "@type.builtin.c", { bg = color.none, fg = color.yellow })
--
-- 		modify_hl(0, "NotifyBackground", { bg = "#000000" })
-- 	end,
-- }

return {
	"rebelot/kanagawa.nvim",
	config = function()
		vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅙", numhl = "" })
		vim.fn.sign_define("DiagnosticSignWarn", { texthl = "DiagnosticSignWarn", text = "󰀦", numhl = "" })
		vim.fn.sign_define("DiagnosticSignHint", { texthl = "DiagnosticSignHint", text = "󰌵", numhl = "" })
		vim.fn.sign_define("DiagnosticSignInfo", {
			texthl = "DiagnosticSignInfo",
			text = "󰀨",
			numhl = "",
		})

		vim.opt.fillchars = "eob: ,vert: "

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

		-- local function modify_hl(ns, name, changes)
		-- 	local def = vim.api.nvim_get_hl(ns, { name = name, link = false })
		-- 	vim.api.nvim_set_hl(ns, name, vim.tbl_deep_extend("force", def, changes))
		-- end

		require("kanagawa").setup({
			compile = false, -- enable compiling the colorscheme
			undercurl = false, -- enable undercurls
			commentStyle = { italic = false },
			functionStyle = {},
			keywordStyle = { italic = false },
			statementStyle = { bold = true },
			typeStyle = { italic = false },
			transparent = true, -- do not set background color
			dimInactive = false, -- dim inactive window `:h hl-NormalNC`
			terminalColors = true, -- define vim.g.terminal_color_{0,17}
			colors = { -- add/modify theme and palette colors
				palette = {},
				theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
			},
			theme = "wave", -- Load "wave" theme
			background = { -- map the value of 'background' option to a theme
				dark = "wave", -- try "dragon" !
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
					-- Save an hlgroup with dark background and dimmed foreground
					-- so that you can use it where your still want darker windows.
					-- E.g.: autocmd TermOpen * setlocal winhighlight=Normal:NormalDark
					NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
					-- Popular plugins that open floats will link to NormalFloat by default;
					-- set their background accordingly if you wish to keep them dark and borderless
					LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
					["@variable.builtin.php"] = { italic = false, fg = pallette.waveRed, bg = "none" },
				}
			end,
		})

		vim.cmd("colorscheme kanagawa")
	end,
}
