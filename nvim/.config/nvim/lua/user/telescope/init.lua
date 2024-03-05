-- Telescope 🔭 - setup and customized pickers
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
})

require("telescope").load_extension("file_browser")
require("telescope").load_extension("fzf")
require("telescope").load_extension("repo")
-- require("telescope").load_extension "media_files"

-- my telescopic customizations
local M = {}

-- grep_string pre-filtered from grep_prompt
local function grep_filtered(opts)
	opts = opts or {}
	require("telescope.builtin").grep_string({
		path_display = { "smart" },
		search = opts.filter_word or "",
	})
end

-- open vim.ui.input dressing prompt for initial filter
function M.grep_prompt()
	vim.ui.input({ prompt = "Rg " }, function(input)
		grep_filtered({ filter_word = input })
	end)
end

-- grep Neovim source using cword
function M.grep_nvim_src()
	require("telescope.builtin").grep_string({
		results_title = "Neovim Source Code",
		path_display = { "smart" },
		search_dirs = {
			"~/vim-dev/sources/neovim/runtime/lua/vim/",
			"~/vim-dev/sources/neovim/src/nvim/",
		},
	})
end

M.project_files = function()
	local _, ret, stderr = utils.get_os_command_output({
		"git",
		"rev-parse",
		"--is-inside-work-tree",
	})

	local gopts = { show_untracked = true }

	local fopts = {}

	gopts.prompt_title = " Find"
	gopts.prompt_prefix = "  "
	gopts.results_title = " Repo Files"
	gopts.file_ignore_patterns = {
		"node_modules",
		".woff",
		".woff2",
		".svg",
		".eot",
		".ttf",
		".jpg",
		".png",
		".jpeg",
		".nib",
		".strings",
		".gif",
		".mp3",
		".mp4",
		".webm",
		".icns",
	}

	fopts.hidden = true
	fopts.file_ignore_patterns = {
		".vim/",
		".local/",
		".cache/",
		"Downloads/",
		".git/",
		"Dropbox/.*",
		"Library/.*",
		".rustup/.*",
		"Movies/",
		".cargo/registry/",
		"~/Remote",
	}

	if ret == 0 then
		require("telescope.builtin").git_files(gopts)
	else
		fopts.results_title = "CWD: " .. vim.fn.getcwd()
		require("telescope.builtin").find_files(fopts)
	end
end

function M.find_configs()
	require("telescope.builtin").find_files({
		prompt_title = " NVim & Term Config Find",
		results_title = "Config Files Results",
		path_display = { "smart" },
		search_dirs = {
			"~/.config/fish/custom",
			"~/.config/nvim",
			"~/Projects/dotfiles",
		},
		layout_strategy = "horizontal",
		layout_config = { preview_width = 0.65, width = 0.75 },
	})
end

function M.nvim_config()
	require("telescope").extensions.file_browser.file_browser({
		prompt_title = " NVim Config Browse",
		cwd = "~/.config/nvim/",
		path_display = { shorten = { len = 1, exclude = { -1 } } },
		layout_strategy = "horizontal",
		layout_config = { preview_width = 0.65, width = 0.75 },
	})
end

function M.file_explorer()
	require("telescope").extensions.file_browser.file_browser({
		prompt_title = " File Browser",
		path_display = { "smart" },
		cwd = "~",
		layout_strategy = "horizontal",
		layout_config = { preview_width = 0.65, width = 0.75 },
	})
end

-- requires repo extension
function M.repo_list()
	local opts = {}
	opts.prompt_title = " Repos"
	opts.file_ignore_patterns = {
		"^" .. vim.env.HOME .. "/%.cache/",
		"^" .. vim.env.HOME .. "/%.cargo/",
		"^" .. vim.env.HOME .. "/%.vim/",
		"^" .. vim.env.HOME .. "/%.config/",
		"^" .. vim.env.HOME .. "/%.local/",
	}
	-- require("telescope").extensions.repo.list(opts)
	require("telescope").extensions.repo.cached_list(opts)
end

return M
