require("nvim-lightbulb").setup()

vim.cmd([[
    let g:cursorhold_updatetime = 200
    autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
]])
