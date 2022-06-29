require("nvim-treesitter.configs").setup {
    ensure_installed = "all",

    highlight = {
        enable = true,
    },

    indent = {
        enable = true,
        -- enable = false,
        disable = {"python"}
    },

    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil,
    },
}
