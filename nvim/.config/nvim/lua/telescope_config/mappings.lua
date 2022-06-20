local key_map = vim.api.nvim_set_keymap

-- find files with names that contain cursor word
key_map(
  "n",
  "<leader>df",
  [[<Cmd>lua require'telescope.builtin'.find_files({find_command={'fd', vim.fn.expand('<cword>')}})<CR>]],
  { noremap = true, silent = true }
)

-- show Workspace Diagnostics
key_map("n", "<space>x", [[<Cmd>lua require'telescope.builtin'.diagnostics()<CR>]], { noremap = true, silent = true })

-- open available commands & run it
key_map(
  "n",
  "<leader>c",
  [[<Cmd>lua require'telescope.builtin'.commands({results_title='Commands Results'})<CR>]],
  { noremap = true, silent = true }
)

-- Telescope oldfiles
key_map(
  "n",
  "<leader>o",
  [[<Cmd>lua require'telescope.builtin'.oldfiles({results_title='Recent-ish Files'})<CR>]],
  { noremap = true, silent = true }
)

-- Telescopic version of FZF's :Lines
key_map("n", "<C-F>", [[<Cmd>lua require'telescope.builtin'.live_grep()<CR>]], { noremap = true, silent = true })

-- Fzf in current buffer
key_map(
  "n",
  "<C-f>",
  [[<Cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>]],
  { noremap = true, silent = true }
)

-- show keymaps
key_map(
  "n",
  "<leader>k",
  [[<Cmd>lua require'telescope.builtin'.keymaps({results_title='Key Maps Results'})<CR>]],
  { noremap = true, silent = true }
)

-- list open buffers
key_map(
  "n",
  "<leader>b",
  [[<Cmd>lua require'telescope.builtin'.buffers({prompt_title = '', results_title='﬘', layout_strategy = 'vertical', layout_config = { width = 0.40, height = 0.55 }})<CR>]],
  { noremap = true, silent = true }
)

-- help tags
key_map(
  "n",
  "<space>h",
  [[<Cmd>lua require'telescope.builtin'.help_tags({results_title='Help Results'})<CR>]],
  { noremap = true, silent = true }
)

-- find files with gitfiles & fallback on find_files
key_map("n", "<leader>e", [[<Cmd>lua require'telescope_config'.project_files()<CR>]], { noremap = true, silent = true })

-- Browse files from cwd - File Browser
vim.cmd [[
    autocmd VimEnter * nunmap <leader>f
    autocmd VimEnter * nmap <leader>f :Telescope file_browser<CR>
]]

-- grep word under cursor
key_map("n", "<leader>g", [[<Cmd>lua require'telescope.builtin'.grep_string()<CR>]], { noremap = true, silent = true })

-- grep word under cursor - case-sensitive (exact word) - made for use with Replace All - see <leader>ra
key_map(
  "n",
  "<leader>G",
  [[<Cmd>lua require'telescope.builtin'.grep_string({word_match='-w'})<CR>]],
  { noremap = true, silent = true }
)

-- Find files in config dirs
key_map("n", "<space>e", [[<Cmd>lua require'telescope_config'.find_configs()<CR>]], { noremap = true, silent = true })

-- find or create neovim configs
key_map("n", "<leader>nc", [[<Cmd>lua require'telescope_config'.nvim_config()<CR>]], { noremap = true, silent = true })

-- go to definitions
key_map("n", "gd", [[:Telescope coc definitions<CR>]], { noremap = true, silent = true })

-- go to implementations
key_map("n", "gi", [[:Telescope coc implementations<CR>]], { noremap = true, silent = true })

-- go to references
key_map("n", "gr", [[:Telescope coc references_used<CR>]], { noremap = true, silent = true })

-- line code actions
key_map("n", "<space><space>", [[:Telescope coc line_code_actions<CR>]], { noremap = true, silent = true })

-- line code actions
key_map("n", "<leader>dg", [[:Telescope coc diagnostics<CR>]], { noremap = true, silent = true })

-- telescope-repo
key_map("n", "<leader>rl", [[<Cmd>lua require'telescope_config'.repo_list()<CR>]], { noremap = true, silent = true })
