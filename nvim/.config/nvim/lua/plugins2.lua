local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git",
        "clone",
        "--depth",
        "1",
        "https://github.com/wbthomason/packer.nvim",
        install_path,
    }
end

vim.cmd [[
augroup packer_sync_plugins
autocmd!
autocmd BufWritePost plugins.lua source <afile> | PackerSync
augroup end
]]

return require("packer").startup {
    function(use)
        use 'sainnhe/everforest'
        use 'joshdick/onedark.vim'
        use {'dracula/vim', as = 'dracula'}
        use 'tpope/vim-repeat'
        use 'tpope/vim-surround'
        use 'tpope/vim-commentary'
        use 'SirVer/ultisnips'
        use 'Raimondi/delimitMate'
        use 'airblade/vim-gitgutter'
        use 'francoiscabrol/ranger.vim'
        use {
            'neoclide/coc.nvim',
            branch = 'release',
        }
        use 'mikelue/vim-maven-plugin'
        use 'chipsenkbeil/distant'
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
        }
        use "nvim-treesitter/nvim-treesitter-refactor"
        use 'nvim-treesitter/nvim-treesitter-textobjects'
        use "David-Kunz/treesitter-unit"
        -- Telescope Extensions
        use 'nvim-telescope/telescope.nvim'
        use "nvim-telescope/telescope-file-browser.nvim"
        use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
        use "lukas-reineke/indent-blankline.nvim"
        use "rcarriga/nvim-notify"
        use "wbthomason/packer.nvim"
        use 'nvim-lua/plenary.nvim'
        use 'nvim-lua/popup.nvim'
        use "chrisbra/Colorizer"
        use 'mfussenegger/nvim-lint'
        use 'fannheyward/telescope-coc.nvim'
        use 'adelarsq/neofsharp.vim'
        use {
            'chipsenkbeil/distant.nvim',
            config = function()
                require('distant').setup {
                    ['*'] = require('distant.settings').chip_default()
                }
            end
        }
        use {
            "nvim-lualine/lualine.nvim",
            requires = { "kyazdani42/nvim-web-devicons", opt = true },
        }
        use 'nekonako/xresources-nvim'
        use {
            'folke/which-key.nvim',
            config = function()
                require("which-key").setup {

                }
            end
        }

        use {
          "lewis6991/gitsigns.nvim",
          requires = { "nvim-lua/plenary.nvim" },
        }

        if PACKER_BOOTSTRAP then
            require("packer").sync()
        end
    end,
    config = {
        display = {
            open_fn = require("packer.util").float,
        },
    },
}
