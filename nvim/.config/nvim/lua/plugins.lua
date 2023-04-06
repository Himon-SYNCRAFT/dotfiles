local fn = vim.fn
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"

if fn.empty(fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = fn.system {
        "git", "clone", "--depth", "1",
        "https://github.com/wbthomason/packer.nvim", install_path
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
        use {"catppuccin/nvim", as = "catppuccin"}
        use 'nvim-lua/plenary.nvim'
        use 'tpope/vim-repeat'
        use 'tpope/vim-surround'
        use 'tpope/vim-commentary'
        use {
            'SirVer/ultisnips',
            requires = {{'honza/vim-snippets', rtp = '.'}},
            config = function()
                vim.g.UltiSnipsExpandTrigger = '<Plug>(ultisnips_expand)'
                vim.g.UltiSnipsJumpForwardTrigger =
                    '<Plug>(ultisnips_jump_forward)'
                vim.g.UltiSnipsJumpBackwardTrigger =
                    '<Plug>(ultisnips_jump_backward)'
                vim.g.UltiSnipsListSnippets = '<c-x><c-s>'
                vim.g.UltiSnipsRemoveSelectModeMappings = 0
            end
        }
        use 'Raimondi/delimitMate'
        use 'francoiscabrol/ranger.vim'
        use 'rbgrouleff/bclose.vim'

        -- Treesitter
        use {"nvim-treesitter/nvim-treesitter", run = ":TSUpdate"}
        use "nvim-treesitter/nvim-treesitter-refactor"
        use 'nvim-treesitter/nvim-treesitter-textobjects'
        use "p00f/nvim-ts-rainbow"
        use "David-Kunz/treesitter-unit"

        -- Telescope Extensions
        use 'nvim-telescope/telescope.nvim'
        use "nvim-telescope/telescope-file-browser.nvim"
        use 'cljoly/telescope-repo.nvim'
        use {"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
        use 'nvim-telescope/telescope-media-files.nvim'
        use 'fannheyward/telescope-coc.nvim'
        use {'stevearc/dressing.nvim'}

        use "lukas-reineke/indent-blankline.nvim"
        use "rcarriga/nvim-notify"
        use "wbthomason/packer.nvim"
        use 'nvim-lua/popup.nvim'
        use 'easymotion/vim-easymotion'
        use {
            "nvim-lualine/lualine.nvim",
            requires = {"kyazdani42/nvim-web-devicons", opt = true}
        }
        use {"dag/vim-fish"}
        use {
            'folke/which-key.nvim',
            config = function() require("which-key").setup {} end
        }

        use {"lewis6991/gitsigns.nvim", requires = {"nvim-lua/plenary.nvim"}}

        -- use {
        --     'rmagatti/auto-session',
        --     config = function()
        --         require('auto-session').setup {
        --             log_level = 'info',
        --             auto_session_suppress_dirs = { '~/', '~/Projects' }
        --         }
        --     end
        -- }

        use 'renerocksai/telekasten.nvim'
        use 'renerocksai/calendar-vim'
        use({
            "iamcco/markdown-preview.nvim",
            run = "cd app && yarn install",
            setup = function() vim.g.mkdp_filetypes = {"markdown"} end,
            ft = {"markdown"}
        })
        use 'phpactor/phpactor'
        use 'nelsyeung/twig.vim'

        use 'folke/trouble.nvim'

        -- debugger
        use 'mfussenegger/nvim-dap'
        use {"rcarriga/nvim-dap-ui", requires = {"mfussenegger/nvim-dap"}}
        use 'Pocco81/dap-buddy.nvim'
        use 'vim-vdebug/vdebug'

        -- lsp
        use {
            "williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig", "jose-elias-alvarez/null-ls.nvim",
            'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path',
            'hrsh7th/cmp-cmdline', 'hrsh7th/nvim-cmp',
            'quangnguyen30192/cmp-nvim-ultisnips', "ray-x/lsp_signature.nvim"
        }

        use {
            'kosayoda/nvim-lightbulb',
            requires = 'antoinemadec/FixCursorHold.nvim'
        }

        use 'aca/emmet-ls'
        use 'nvim-tree/nvim-web-devicons'
        use({
            "ziontee113/icon-picker.nvim",
            config = function()
                require("icon-picker").setup({disable_legacy_commands = true})
            end
        })

        use('kmonad/kmonad-vim')

        if PACKER_BOOTSTRAP then require("packer").sync() end
    end,
    config = {display = {open_fn = require("packer.util").float}}
}
