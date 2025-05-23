return {
	"stevearc/dressing.nvim",
	config = function()
		require("dressing").setup({
			input = {
				-- Set to false to disable the vim.ui.input implementation
				enabled = true,

				-- Default prompt string
				default_prompt = "Input:",

				-- Can be 'left', 'right', or 'center'
				prompt_align = "left",

				-- When true, <Esc> will close the modal
				insert_only = true,

				-- These are passed to nvim_open_win
				border = "rounded",
				-- 'editor' and 'win' will default to being centered
				relative = "cursor",

				-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				prefer_width = 40,
				width = nil,
				-- min_width and max_width can be a list of mixed types.
				-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
				max_width = { 140, 0.9 },
				min_width = { 20, 0.2 },

				-- Window transparency (0-100)
				winblend = 10,
				-- Change default highlight groups (see :help winhl)
				winhighlight = "",

				override = function(conf)
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					return conf
				end,

				-- see :help dressing_get_config
				get_config = nil,
			},

			select = {
				-- Set to false to disable the vim.ui.select implementation
				enabled = true,

				-- Priority list of preferred vim.select implementations
				backend = { "telescope" },

				-- Trim trailing `:` from prompt
				trim_prompt = true,

				-- Options for telescope selector
				-- These are passed into the telescope picker directly. Can be used like:
				-- telescope = require('telescope.themes').get_ivy({...})
				telescope = require("telescope.themes").get_cursor(),

				-- Used to override format_item. See :help dressing-format
				format_item_override = {},

				-- see :help dressing_get_config
				get_config = function(opts)
					if opts.kind == "codeaction" then
						return {
							backend = "telescope",
						}
					end
				end,
			},
		})
	end,
}
