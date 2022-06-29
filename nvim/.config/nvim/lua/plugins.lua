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
        use {'dracula/vim', as = 'dracula'}
        -- use { "catppuccin/nvim", as = "catppuccin" }
        use 'tpope/vim-repeat'
        use 'tpope/vim-surround'
        use 'tpope/vim-commentary'
        use 'SirVer/ultisnips'
        use 'Raimondi/delimitMate'
        -- use 'francoiscabrol/ranger.vim'
        use {
            'kyazdani42/nvim-tree.lua',
            requires = {
                'kyazdani42/nvim-web-devicons', -- optional, for file icons
            },
            tag = 'nightly' -- optional, updated every week. (see issue #1193)
        }

        use {
            'neoclide/coc.nvim',
            branch = 'release',
        }
        use {
            "nvim-treesitter/nvim-treesitter",
            run = ":TSUpdate",
        }
        use "nvim-treesitter/nvim-treesitter-refactor"
        use 'nvim-treesitter/nvim-treesitter-textobjects'
        use "p00f/nvim-ts-rainbow"
        use "David-Kunz/treesitter-unit"

        -- Telescope Extensions
        use 'nvim-telescope/telescope.nvim'
        use "nvim-telescope/telescope-file-browser.nvim"
        use 'cljoly/telescope-repo.nvim'
        use { "nvim-telescope/telescope-fzf-native.nvim", run = "make" }
        use 'fannheyward/telescope-coc.nvim'

        use "lukas-reineke/indent-blankline.nvim"
        use "rcarriga/nvim-notify"
        use "wbthomason/packer.nvim"
        use 'nvim-lua/plenary.nvim'
        use 'nvim-lua/popup.nvim'
        use 'mfussenegger/nvim-lint'
        use 'easymotion/vim-easymotion'
        use {
            "nvim-lualine/lualine.nvim",
            requires = { "kyazdani42/nvim-web-devicons", opt = true },
        }
        use { "dag/vim-fish" }
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

        use {
          'rmagatti/auto-session',
          config = function()
            require('auto-session').setup {
              log_level = 'info',
              auto_session_suppress_dirs = {'~/', '~/Projects'}
            }
          end
        }

        use 'renerocksai/telekasten.nvim'

        use 'phpactor/phpactor'

        -- use 'folke/trouble.nvim'

        -- debugger
        use 'mfussenegger/nvim-dap'
        use { "rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"} }
        use 'Pocco81/dap-buddy.nvim'
        use 'vim-vdebug/vdebug'

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
