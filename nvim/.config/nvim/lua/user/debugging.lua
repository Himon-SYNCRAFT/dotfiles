require('dapui').setup()

local key_map = vim.api.nvim_set_keymap
local dap, dapui = require('dap'), require('dapui')

dap.listeners.after.event_initialized['dapui_config'] = function()
    dapui.open()
end

dap.listeners.before.event_terminaed['dapui_config'] = function()
    dapui.close()
end

dap.listeners.before.event_exited['dapui_config'] = function()
    dapui.close()
end

dap.adapters.php = {
    type = 'executable',
    command = 'node',
    args = { '/home/himon/Projects/vscode-php-debug/out/phpDebug.js'}
}

dap.configurations.php = {
    {
        type = 'php',
        request = 'launch',
        name = 'Listen for Xdebug',
        port = 9003,
        log = true,
        serverSourceRoot = 'localhost:8000',
        localSourceRoot = '/home/himon/Projects/php/mokosh',
        -- stopOnEntry = true,
    }
}

-- -- Toggle breakpoint
-- key_map(
--     "n",
--     "<space>b",
--     [[<Cmd>lua require'dap'.toggle_breakpoint()<CR>]],
--     { noremap = true, silent = true }
-- )

-- -- Start or continue
-- key_map(
--     "n",
--     "<F4>",
--     [[<Cmd>lua require'dap'.continue()<CR>]],
--     { noremap = true, silent = true }
-- )

-- -- Step into
-- key_map(
--     "n",
--     "<F5>",
--     [[<Cmd>lua require'dap'.step_into()<CR>]],
--     { noremap = true, silent = true }
-- )

-- -- Step over
-- key_map(
--     "n",
--     "<F6>",
--     [[<Cmd>lua require'dap'.step_over()<CR>]],
--     { noremap = true, silent = true }
-- )

-- -- Step over
-- key_map(
--     "n",
--     "<F7>",
--     [[<Cmd>lua require'dap'.step_out()<CR>]],
--     { noremap = true, silent = true }
-- )

-- key_map(
--     "n",
--     "<F8>",
--     [[<Cmd>lua require'dapui'.toggle()<CR>]],
--     { noremap = true, silent = true }
-- )
