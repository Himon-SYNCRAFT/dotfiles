local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

vim.cmd [[let mapleader=',']]

vim.cmd [[
    cnoreabbrev W! w!
    cnoreabbrev Q! q!
    cnoreabbrev Qall! qall!
    cnoreabbrev Wq wq
    cnoreabbrev Wa wa
    cnoreabbrev wQ wq
    cnoreabbrev WQ wq
    cnoreabbrev W w
    cnoreabbrev Q q
    cnoreabbrev Qall qall
]]

local mapopts = {noremap = true, silent = true}
-- split focus
map("n", "<C-j>", "<C-w>j", mapopts)
map("n", "<C-k>", "<C-w>k", mapopts)
map("n", "<C-l>", "<C-w>l", mapopts)
map("n", "<C-h>", "<C-w>h", mapopts)

-- splits
map("n", "<leader>h", ":<C-u>split<CR>", mapopts)
map("n", "<leader>v", ":<C-u>vsplit<CR>", mapopts)

-- move indentation
map("v", "<", "<gv", mapopts)
map("v", ">", ">gv", mapopts)

-- trouble
map("n", "<leader>dg", "<cmd>Trouble<cr>", mapopts)

-- ranger
map("n", "<F2>", ":Ranger<CR>", mapopts)
map("n", "<F3>", ":RangerWorkingDirectory<CR>", mapopts)

-- easymotion
map("n", "s", "<Plug>(easymotion-overwin-f2)", mapopts)

-- telescope
--
-- find files with names that contain cursor word
map("n", "<leader>df",
    [[<Cmd>lua require'telescope.builtin'.find_files({find_command={'fd', vim.fn.expand('<cword>')}})<CR>]],
    mapopts)

-- show Workspace Diagnostics
map("n", "<space>x", [[<Cmd>lua require'telescope.builtin'.diagnostics()<CR>]],
    mapopts)

-- open available commands & run it
map("n", "<leader>c",
    [[<Cmd>lua require'telescope.builtin'.commands({results_title='Commands Results'})<CR>]],
    mapopts)

-- Telescope oldfiles
map("n", "<leader>o",
    [[<Cmd>lua require'telescope.builtin'.oldfiles({results_title='Recent-ish Files'})<CR>]],
    mapopts)

-- Telescopic version of FZF's :Lines
map("n", "<C-F>", [[<Cmd>lua require'telescope.builtin'.live_grep()<CR>]],
    mapopts)

-- Fzf in current buffer
map("n", "<C-f>",
    [[<Cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>]],
    mapopts)

-- show keymaps
map("n", "<leader>k",
    [[<Cmd>lua require'telescope.builtin'.keymaps({results_title='Key Maps Results'})<CR>]],
    mapopts)

-- list open buffers
map("n", "<leader>b",
    [[<Cmd>lua require'telescope.builtin'.buffers({prompt_title = '', results_title='﬘', layout_strategy = 'vertical', layout_config = { width = 0.40, height = 0.55 }})<CR>]],
    mapopts)

-- help tags
map("n", "<space>h",
    [[<Cmd>lua require'telescope.builtin'.help_tags({results_title='Help Results'})<CR>]],
    mapopts)

-- find files with gitfiles & fallback on find_files
map("n", "<leader>e", [[<Cmd>lua require'user.telescope'.project_files()<CR>]],
    mapopts)

-- Browse files from cwd - File Browser
-- autocmd VimEnter * nunmap <leader>f
vim.cmd [[
    autocmd VimEnter * nmap <leader>f :Telescope file_browser<CR>
]]

-- grep word under cursor
map("n", "<leader>g", [[<Cmd>lua require'telescope.builtin'.grep_string()<CR>]],
    mapopts)

-- grep word under cursor - case-sensitive (exact word) - made for use with Replace All - see <leader>ra
map("n", "<leader>G",
    [[<Cmd>lua require'telescope.builtin'.grep_string({word_match='-w'})<CR>]],
    mapopts)

-- Find files in config dirs
map("n", "<space>e", [[<Cmd>lua require'user.telescope'.find_configs()<CR>]],
    mapopts)

-- find or create neovim configs
map("n", "<leader>nc", [[<Cmd>lua require'user.telescope'.nvim_config()<CR>]],
    mapopts)

-- go to definitions
-- map("n", "gd", [[:Telescope coc definitions<CR>]], mapopts)
map("n", "gd", [[:Telescope lsp_definitions<CR>]], mapopts)

-- go to implementations
-- map("n", "gi", [[:Telescope coc implementations<CR>]], mapopts)
map("n", "gi", [[:Telescope lsp_implementations<CR>]], mapopts)

-- go to references
-- map("n", "gr", [[:Telescope coc references_used<CR>]], mapopts)
map("n", "gr", [[:Telescope lsp_references<CR>]], mapopts)

-- line code actions
-- map("n", "<space><space>", [[:Telescope coc line_code_actions<CR>]], mapopts)

-- line code actions
-- map("n", "<leader>dg", [[:Telescope coc diagnostics<CR>]], mapopts)
-- map("n", "<leader>dg", [[:Telescope diagnostics<CR>]], mapopts)

-- telescope-repo
map("n", "<leader>rl", [[<Cmd>lua require'user.telescope'.repo_list()<CR>]],
    mapopts)
map("n", "<leader>i", [[<Cmd>IconPickerNormal emoji<CR>]], mapopts)

-- telekasten
map("n", "<leader>z", ":Telekasten panel<CR>", mapopts)
map("n", "<leader>zn", ":Telekasten new_templated_note<CR>", mapopts)
map("n", "<leader>zb", ":Telekasten show_backlinks<CR>", mapopts)
map("n", "<leader>ze", ":Telekasten find_notes<CR>", mapopts)
map("n", "<leader>zf", ":Telekasten find_friends<CR>", mapopts)
map("n", "<leader>zg", ":Telekasten search_notes<CR>", mapopts)
map("n", "<leader>zrn", ":Telekasten rename_note<CR>", mapopts)
map("n", "<leader>zt", ":Telekasten show_tags<CR>", mapopts)
map("n", "<leader>zz", ":Telekasten follow_link<CR>", mapopts)
