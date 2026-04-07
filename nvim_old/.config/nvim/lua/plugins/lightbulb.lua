return {
    "kosayoda/nvim-lightbulb",
    dependencies = "antoinemadec/FixCursorHold.nvim",

	config = function()
		require("nvim-lightbulb").setup({
			sign = {
				enabled = false,
			},
			virtual_text = {
				enabled = true,
				-- Text to show in the virt_text.
				text = "💡",
				lens_text = "🔎",
				-- Position of virtual text given to |nvim_buf_set_extmark|.
				-- Can be a number representing a fixed column (see `virt_text_pos`).
				-- Can be a string representing a position (see `virt_text_win_col`).
				pos = "eol",
				-- Highlight group to highlight the virtual text.
				hl = "LightBulbVirtualText",
				-- How to combine other highlights with text highlight.
				-- See `hl_mode` of |nvim_buf_set_extmark|.
				hl_mode = "combine",
			},
		})

		vim.cmd([[
            let g:cursorhold_updatetime = 200
            autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
        ]])
	end,
}
