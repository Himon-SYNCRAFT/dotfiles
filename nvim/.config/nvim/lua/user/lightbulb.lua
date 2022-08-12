require('nvim-lightbulb').setup()

vim.cmd [[
    let g:cursorhold_updatetime = 100
    autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
]]
