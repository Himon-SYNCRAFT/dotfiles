-- lua/plugins/mini_files.lua
require("mini.files").setup({
    content = { filter = nil, prefix = nil, sort = nil },
    mappings = {
        close = "q",
        go_in = "l",
        go_in_plus = "<CR>",
        go_out = "h",
        go_out_plus = "H",
        reset = "<BS>",
        reveal_cwd = "@",
        show_help = "g?",
        synchronize = "=",
        trim_left = "<",
        trim_right = ">",
    },
    options = {
        permanent_delete = false,
        use_as_default_explorer = true,
    },
    windows = {
        max_number = math.huge,
        preview = true,
        width_focus = 50,
        width_nofocus = 15,
        width_preview = 120,
    },
})

local mapopts = { noremap = true, silent = true }
vim.keymap.set("n", "<F2>", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>", mapopts)
vim.keymap.set("n", "<F3>", "<cmd>lua MiniFiles.open(nil, false)<CR>", mapopts)
