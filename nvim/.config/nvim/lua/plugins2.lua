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
        -- use 'airblade/vim-gitgutter'
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
        use 'cljoly/telescope-repo.nvim'
        use 'glepnir/dashboard-nvim'
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
        use 'easymotion/vim-easymotion'
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
          config = function ()
            require('gitsigns').setup {
                signs = {
                   add          = {hl = 'GitSignsAdd'   , text = '│', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
                    change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                    delete       = {hl = 'GitSignsDelete', text = '_', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
                    changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
                },
                signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    interval = 1000,
                    follow_files = true
                },
                attach_to_untracked = true,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                   virt_text = true,
                   virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                   delay = 1000,
                   ignore_whitespace = false,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                max_file_length = 40000,
                preview_config = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                yadm = {
                    enable = false
                },
            }
              end
        }

        use 'phpactor/phpactor'

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
