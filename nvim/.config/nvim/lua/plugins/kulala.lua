return {
	"mistweaverco/kulala.nvim",
	keys = {
		{ "<space>ss", desc = "Send request" },
		{ "<space>aa", desc = "Send all requests" },
		-- { "<leader>Rb", desc = "Open scratchpad" },
	},
	ft = { "http", "rest" },
	opts = {
		global_keymaps = true,
		global_keymaps_prefix = "<space>r",
		kulala_keymaps_prefix = "",
	},
}
