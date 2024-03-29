local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
end

vim.cmd([[
augroup packer_sync_plugins
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]])

return require("packer").startup({
	function(use)
		use("wbthomason/packer.nvim")

		-- use({ "catppuccin/nvim", as = "catppuccin" })
		-- use 'folke/tokyonight.nvim'
		-- use("rebelot/kanagawa.nvim")
		use("rose-pine/neovim")
		--
		-- use("lukas-reineke/virt-column.nvim")
		use("nvim-lua/plenary.nvim")
		use("tpope/vim-repeat")
		use("tpope/vim-surround")
		use("tpope/vim-commentary")
		use({
			"SirVer/ultisnips",
			requires = { { "honza/vim-snippets", rtp = "." } },
			config = function()
				vim.g.UltiSnipsExpandTrigger = "<Plug>(ultisnips_expand)"
				vim.g.UltiSnipsJumpForwardTrigger = "<Plug>(ultisnips_jump_forward)"
				vim.g.UltiSnipsJumpBackwardTrigger = "<Plug>(ultisnips_jump_backward)"
				vim.g.UltiSnipsListSnippets = "<c-x><c-s>"
				vim.g.UltiSnipsRemoveSelectModeMappings = 0
			end,
		})
		use("Raimondi/delimitMate")
		use("francoiscabrol/ranger.vim")
		use("rbgrouleff/bclose.vim")

		-- ai
		use("Exafunction/codeium.vim")
		-- use({
		-- 	"dpayne/CodeGPT.nvim",
		-- 	requires = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
		-- 	config = function()
		-- 		require("codegpt.config")
		-- 	end,
		-- })

		-- Treesitter
		use({
			"nvim-treesitter/nvim-treesitter",
			run = function()
				local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
				ts_update()
			end,
		})
		use("p00f/nvim-ts-rainbow")

		-- Telescope Extensions
		use("nvim-telescope/telescope.nvim")
		use("nvim-telescope/telescope-file-browser.nvim")
		use("cljoly/telescope-repo.nvim")
		use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })
		-- use("nvim-telescope/telescope-media-files.nvim")
		use({ "stevearc/dressing.nvim" })

		-- use("rcarriga/nvim-notify")
		-- use("easymotion/vim-easymotion")
		-- use 'chaoren/vim-wordmotion'
		-- use({
		-- 	"nvim-lualine/lualine.nvim",
		-- 	requires = { "kyazdani42/nvim-web-devicons", opt = true },
		-- })
		-- use({ "dag/vim-fish" })
		-- use({
		-- 	"folke/which-key.nvim",
		-- 	config = function()
		-- 		require("which-key").setup({})
		-- 	end,
		-- })

		use({ "lewis6991/gitsigns.nvim", requires = { "nvim-lua/plenary.nvim" } })

		use("phpactor/phpactor")

		-- use("nelsyeung/twig.vim")

		use("folke/trouble.nvim")

		-- debugger
		-- use("mfussenegger/nvim-dap")
		-- use({ "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } })
		-- use("Pocco81/dap-buddy.nvim")
		-- use("vim-vdebug/vdebug")

		-- lsp
		use({
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"nvimtools/none-ls.nvim",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"quangnguyen30192/cmp-nvim-ultisnips",
			"ray-x/lsp_signature.nvim",
		})

		use({
			"kosayoda/nvim-lightbulb",
			requires = "antoinemadec/FixCursorHold.nvim",
		})

		use("nvim-tree/nvim-web-devicons")
		-- use({
		-- 	"ziontee113/icon-picker.nvim",
		-- 	config = function()
		-- 		require("icon-picker").setup({ disable_legacy_commands = true })
		-- 	end,
		-- })

		-- use({
		-- 	"folke/noice.nvim",
		-- 	requires = { "MunifTanjim/nui.nvim", "rcarriga/nvim-notify" },
		-- })

		-- db
		use("tpope/vim-dadbod")
		use("kristijanhusak/vim-dadbod-ui")
		use("kristijanhusak/vim-dadbod-completion")

		-- use("kmonad/kmonad-vim")
		-- use("elkowar/yuck.vim")

		-- use({
		-- 	"epwalsh/obsidian.nvim",
		-- 	requires = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
		-- })

		use("tjdevries/templ.nvim")

		use({
			"rmagatti/auto-session",
			config = function()
				require("auto-session").setup({
					log_level = "error",
					auto_session_suppress_dirs = {
						"~/",
						"~/Projects",
						"~/Downloads",
						"/",
					},
				})
			end,
		})

		if PACKER_BOOTSTRAP then
			require("packer").sync()
		end
	end,
	config = { display = { open_fn = require("packer.util").float } },
})
