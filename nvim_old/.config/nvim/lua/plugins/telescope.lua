return {
	"nvim-telescope/telescope.nvim",
	dependencies = {
		"nvim-telescope/telescope-file-browser.nvim",
		"cljoly/telescope-repo.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},

	config = function()
		-- Telescope - setup and customized pickers
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local utils = require("telescope.utils")

		-- https://github.com/nvim-telescope/telescope.nvim/issues/1048
		local telescope_custom_actions = {}

		function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
			local picker = action_state.get_current_picker(prompt_bufnr)
			local num_selections = #picker:get_multi_selection()
			if not num_selections or num_selections <= 1 then
				actions.add_selection(prompt_bufnr)
			end
			actions.send_selected_to_qflist(prompt_bufnr)
			vim.cmd("cfdo " .. open_cmd)
		end

		function telescope_custom_actions.multi_selection_open(prompt_bufnr)
			telescope_custom_actions._multiopen(prompt_bufnr, "edit")
		end

		require("telescope").setup({
			extensions = {
				fzf = {
					fuzzy = true, -- false will only do exact matching
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case", -- this is default
				},
				file_browser = { hidden = true },
				-- ["ui-select"] = {
				--   require("telescope.themes").get_cursor(),
				-- },
			},
			defaults = {
				preview = { timeout = 500, msg_bg_fillchar = "" },
				multi_icon = " ",
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},
				prompt_prefix = "❯ ",
				selection_caret = "❯ ",
				sorting_strategy = "ascending",
				color_devicons = true,
				layout_config = {
					prompt_position = "bottom",
					horizontal = {
						width_padding = 0.04,
						height_padding = 0.1,
						preview_width = 0.6,
					},
					vertical = {
						width_padding = 0.05,
						height_padding = 1,
						preview_height = 0.5,
					},
				},

				-- using custom temp multi-select maps
				-- https://github.com/nvim-telescope/telescope.nvim/issues/1048
				mappings = {
					n = {
						["<Del>"] = actions.close,
						["<C-A>"] = telescope_custom_actions.multi_selection_open,
					},
					i = {
						["<esc>"] = actions.close,
						["<C-A>"] = telescope_custom_actions.multi_selection_open,
						["<C-j>"] = actions.move_selection_next,
						["<C-k>"] = actions.move_selection_previous,
					},
				},
				dynamic_preview_title = true,
			},
			pickers = {
				find_files = {
					follow = true,
				},
			},
		})

		require("telescope").load_extension("file_browser")
		require("telescope").load_extension("fzf")
		require("telescope").load_extension("repo")
		-- require("telescope").load_extension "media_files"
	end,
}
