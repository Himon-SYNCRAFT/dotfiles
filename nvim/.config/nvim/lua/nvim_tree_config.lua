-- require("nvim-tree").setup()

require("nvim-tree").setup({
    sort_by = "extension",
    hijack_cursor = true,
    diagnostics = {
        enable = false
    },

    filesystem_watchers = {
        enable = true
    },

    view = {
        adaptive_size = true,
        number = true,
        relativenumber = true,
        signcolumn = 'no',
        mappings = {
            custom_only = true,
            list = {
                { key = "mf", action = "create" },
                { key = "<CR>", action = "edit" },
                { key = "d", action = "remove" },
                { key = "x", action = "cut" },
                { key = "y", action = "copy" },
                { key = "p", action = "paste" },
                { key = "rn", action = "full_rename" },
                { key = "q", action = "close" },
                { key = "h", action = "toggle_dotfiles" },
                { key = "/", action = "live_filter" },
            }
        },
    },

    renderer = {
        group_empty = true,
    },

    actions = {
        open_file = {
            quit_on_open = true,
            window_picker = {
                enable = false,
            }
        }
    },
})
