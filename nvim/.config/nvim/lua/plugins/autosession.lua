return {
	"rmagatti/auto-session",
	config = function()
		require("auto-session").setup({
			log_level = "error",
			auto_session_suppress_dirs = {
				"~/",
				"~/Projects",
				"~/Downloads",
				"~/.config",
				"/",
			},
			session_lens = {
				theme_conf = {
					border = true,
				},
				theme = "dropdown",
				previewer = false,
			},
		})
	end,
}
