return {
	"olimorris/codecompanion.nvim",
	opts = {
		strategies = {
			-- Change the default chat adapter
			chat = {
				adapter = "qwen",
				inline = "qwen",
			},
			inline = {
				adapter = "qwen",
			},
			cmd = {
				adapter = "qwen",
			},
			-- chat = {
			-- 	adapter = "r1",
			-- 	inline = "r1",
			-- },
			-- inline = {
			-- 	adapter = "r1",
			-- },
			-- cmd = {
			-- 	adapter = "r1",
			-- },
		},
		adapters = {
			qwen = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "qwen", -- Give this adapter a different name to differentiate it from the default ollama adapter
					schema = {
						model = {
							default = "qwen2.5-coder:7b",
						},
					},
				})
			end,
			r1 = function()
				return require("codecompanion.adapters").extend("ollama", {
					name = "deepseek-r1", -- Give this adapter a different name to differentiate it from the default ollama adapter
					schema = {
						model = {
							default = "deepseek-r1",
						},
					},
				})
			end,
		},
		opts = {
			log_level = "DEBUG",
		},
		display = {
			diff = {
				enabled = true,
				close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
				layout = "vertical", -- vertical|horizontal split for default provider
				opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
				provider = "default", -- default|mini_diff
			},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
	},
	config = function(_, opts)
		local spinner = require("plugins.codecompanion.spinner")
		spinner:init()

		-- Setup the entire opts table
		require("codecompanion").setup(opts)
	end,
}
