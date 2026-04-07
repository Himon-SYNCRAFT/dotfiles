-- lua/plugins/autosession.lua
require("auto-session").setup({
    log_level = "error",
    auto_session_suppress_dirs = {
        "~/", "~/Projects", "~/Downloads", "~/.config", "/",
    },
    session_lens = {
        theme_conf = { border = true },
        theme = "dropdown",
        previewer = false,
    },
})

vim.keymap.set("n", "<leader>p",
    function() require("auto-session.pickers").open_session_picker() end,
    { noremap = true, silent = true })
