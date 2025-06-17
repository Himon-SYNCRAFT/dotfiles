vim.diagnostic.config({
	-- virtual_lines = {
	-- 	-- Only show virtual line diagnostics for the current cursor line
	-- 	current_line = true,
	-- },
	signs = {
		-- text = {
		-- 	[vim.diagnostic.severity.ERROR] = "",
		-- 	[vim.diagnostic.severity.WARN] = "",
		-- 	[vim.diagnostic.severity.INFO] = "",
		-- 	[vim.diagnostic.severity.HINT] = "",
		-- },
		numhl = {
			[vim.diagnostic.severity.WARN] = "WarningMsg",
			[vim.diagnostic.severity.ERROR] = "ErrorMsg",
			[vim.diagnostic.severity.INFO] = "DiagnosticInfo",
			[vim.diagnostic.severity.HINT] = "DiagnosticHint",
		},
	},

	virtual_text = true,
})
