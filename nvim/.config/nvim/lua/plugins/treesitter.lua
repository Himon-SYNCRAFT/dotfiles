return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	init = function(plugin)
		require("lazy.core.loader").add_to_rtp(plugin)
	end,
	config = function()
		---@diagnostic disable-next-line: missing-fields
		require("nvim-treesitter.configs").setup({
			auto_install = true,
			ensure_installed = {
				"bash",
				"c",
				"cmake",
				"comment",
				"cpp",
				"css",
				"diff",
				"dockerfile",
				"dot",
				"fish",
				"go",
				"groovy",
				"html",
				"ini",
				"json",
				"lua",
				"make",
				"ocaml",
				"ocaml_interface",
				"php",
				"phpdoc",
				"python",
				"scss",
				"toml",
				"templ",
				"tsx",
				"twig",
				"typescript",
				"yaml",
				"markdown",
				"markdown_inline", -- , 'javascript',
			},

			highlight = {
				enable = true,
				additional_vim_regex_highlighting = { "markdown" },
			},

			indent = {
				enable = true,
				disable = { "python" },
			},
		})
	end,
}
