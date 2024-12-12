local map = vim.api.nvim_set_keymap
local unmap = vim.api.nvim_del_keymap

vim.cmd([[
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
]])

local mapopts = { noremap = true, silent = true }
-- split focus
map("n", "<C-j>", "<C-w>j", mapopts)
map("n", "<C-k>", "<C-w>k", mapopts)
map("n", "<C-l>", "<C-w>l", mapopts)
map("n", "<C-h>", "<C-w>h", mapopts)

map("t", "<C-j>", "<C-\\><C-n><C-w>j", mapopts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", mapopts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", mapopts)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", mapopts)

-- splits
map("n", "<leader>h", ":<C-u>split<CR>", mapopts)
map("n", "<leader>v", ":<C-u>vsplit<CR>", mapopts)

local function vimdir()
	local vd = ""

	local workspace_folders = vim.lsp.buf.list_workspace_folders()
	if workspace_folders and #workspace_folders > 0 then
		vd = workspace_folders[1]
	else
		vd = vim.fn.expand("%:p:h")
	end

	return vd
end

local function open_terminal()
	vim.cmd(string.format("let $VIM_DIR = '%s'", vimdir()))
	vim.cmd("10split")
	vim.cmd("terminal fish")
	vim.api.nvim_input("Acd $VIM_DIR<cr>clear<cr>")
	vim.cmd("se winfixheight")
end

-- terminal
vim.keymap.set("n", "<leader>s", open_terminal, mapopts)

-- move indentation
map("v", "<", "<gv", mapopts)
map("v", ">", ">gv", mapopts)

-- trouble
map("n", "<leader>da", "<cmd>Trouble diagnostics toggle<cr>", mapopts)
map("n", "<leader>dg", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", mapopts)
map(
	"n",
	"<leader>de",
	"<cmd>Trouble diagnostics toggle filter = { buf = 0, severity = vim.diagnostic.severity.ERROR }<cr>",
	mapopts
)
map("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", mapopts)
map("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", mapopts)

map("n", "<leader>dh", "[[<Cmd>lua vim.diagnostic.disable()<CR>]]", mapopts)
map("n", "<leader>ds", "[[<Cmd>lua vim.diagnostic.enable()<CR>]]", mapopts)

-- netrw
-- map("n", "<F4>", ":Explore<CR>", mapopts)

-- ranger
-- map("n", "<F2>", ":Ranger<CR>", mapopts)
-- map("n", "<F3>", ":RangerWorkingDirectory<CR>", mapopts)
--
-- vim.keymap.set("n", "<F2>", function()
-- 	local oil = require("oil")
-- 	oil.open()

-- 	vim.wait(1000, function()
-- 		return oil.get_cursor_entry() ~= nil
-- 	end)
-- 	if oil.get_cursor_entry() then
-- 		oil.open_preview()
-- 	end
-- end)
map("n", "<F2>", "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0), false)<CR>", mapopts)
map("n", "<F3>", "<cmd>lua MiniFiles.open(nil, false)<CR>", mapopts)

-- map("n", "<F2>", "<CMD>Oil<Cr>", mapopts)

-- easymotion
-- map("n", "s", "<Plug>(easymotion-overwin-f2)", mapopts)

-- telescope
--
-- find files with names that contain cursor word
map(
	"n",
	"<leader>df",
	[[<Cmd>lua require'telescope.builtin'.find_files({find_command={'fd', vim.fn.expand('<cword>')}})<CR>]],
	mapopts
)

-- show Workspace Diagnostics
map("n", "<space>x", [[<Cmd>lua require'telescope.builtin'.diagnostics()<CR>]], mapopts)

-- open available commands & run it
map("n", "<leader>c", [[<Cmd>lua require'telescope.builtin'.commands({results_title='Commands Results'})<CR>]], mapopts)

-- Telescope oldfiles
map("n", "<leader>o", [[<Cmd>lua require'telescope.builtin'.oldfiles({results_title='Recent-ish Files'})<CR>]], mapopts)

-- Fzf in current buffer
map("n", "<C-f>", [[<Cmd>lua require'telescope.builtin'.current_buffer_fuzzy_find()<CR>]], mapopts)

-- show keymaps
map("n", "<leader>k", [[<Cmd>lua require'telescope.builtin'.keymaps({results_title='Key Maps Results'})<CR>]], mapopts)

-- list open buffers
map(
	"n",
	"<leader>b",
	[[<Cmd>lua require'telescope.builtin'.buffers({prompt_title = '', results_title='﬘', layout_strategy = 'vertical', layout_config = { width = 0.40, height = 0.55 }})<CR>]],
	mapopts
)

-- help tags
map("n", "<space>h", [[<Cmd>lua require'telescope.builtin'.help_tags({results_title='Help Results'})<CR>]], mapopts)

-- find files with gitfiles & fallback on find_files
map("n", "<leader>e", [[<Cmd>lua require'user.telescope'.project_files()<CR>]], mapopts)

map("n", "<leader>f", [[<Cmd>Telescope live_grep<CR>]], mapopts)

-- grep word under cursor
-- map("n", "<leader>g", [[<Cmd>lua require'telescope.builtin'.grep_string()<CR>]], mapopts)

-- grep word under cursor - case-sensitive (exact word) - made for use with Replace All - see <leader>ra
map("n", "<leader>G", [[<Cmd>lua require'telescope.builtin'.grep_string({word_match='-w'})<CR>]], mapopts)

-- Find files in config dirs
map("n", "<space>e", [[<Cmd>lua require'user.telescope'.find_configs()<CR>]], mapopts)

-- find or create neovim configs
-- map("n", "<leader>nc", [[<Cmd>lua require'user.telescope'.nvim_config()<CR>]],
--     mapopts)
-- map("n", "<leader>nc", [[<Cmd>call OpenRangerIn("~/.config/nvim", "tabedit ")<CR>]], mapopts)

-- go to definitions
-- map("n", "gd", [[:Telescope coc definitions<CR>]], mapopts)
-- map("n", "gd", [[:Telescope lsp_definitions<CR>]], mapopts)
vim.keymap.set("n", "gd", function()
	-- require("telescope.builtin").lsp_definitions({ jump_type = "vsplit" })
	-- require("telescope.builtin").lsp_definitions({ jump_type = "vsplit", reuse_window = false })
	require("telescope.builtin").lsp_definitions()
end, mapopts)

-- go to implementations
-- map("n", "gi", [[:Telescope coc implementations<CR>]], mapopts)
map("n", "gi", [[:Telescope lsp_implementations<CR>]], mapopts)

-- go to references
-- map("n", "gr", [[:Telescope coc references_used<CR>]], mapopts)
map("n", "gr", [[:Telescope lsp_references<CR>]], mapopts)

vim.keymap.set("n", "<leader>p", require("auto-session.session-lens").search_session, mapopts)

-- telescope-repo
map("n", "<leader>rl", [[<Cmd>lua require'user.telescope'.repo_list()<CR>]], mapopts)
-- map("n", "<leader>i", [[<Cmd>IconPickerNormal emoji<CR>]], mapopts)

-- telekasten
-- map("n", "<leader>z", ":Telekasten panel<CR>", mapopts)
-- map("n", "<leader>zb", ":Telekasten show_backlinks<CR>", mapopts)
-- map("n", "<leader>ze", ":Telekasten find_notes<CR>", mapopts)
-- map("n", "<leader>zf", ":Telekasten find_friends<CR>", mapopts)
-- map("n", "<leader>zg", ":Telekasten search_notes<CR>", mapopts)
-- map("n", "<leader>zl", ":Telekasten insert_link<CR>", mapopts)
-- map("n", "<leader>zn", ":Telekasten new_templated_note<CR>", mapopts)
-- map("n", "<leader>zrn", ":Telekasten rename_note<CR>", mapopts)
-- map("n", "<leader>zt", ":Telekasten show_tags<CR>", mapopts)
-- map("n", "<leader>zz", ":Telekasten follow_link<CR>", mapopts)

map("n", "<leader>db", ":DBUIToggle<CR>", mapopts)

vim.keymap.set("n", "gf", function()
	if require("obsidian").util.cursor_on_markdown_link() then
		return "<cmd>ObsidianFollowLink<CR>"
	else
		return "gf"
	end
end, { noremap = false, expr = true })

-- codeium
vim.keymap.set("i", "<C-o>", function()
	return vim.fn["codeium#Accept"]()
end, { expr = true })
-- vim.keymap.set('i', '<C-]>',
--                function() return vim.fn['codeium#CycleCompletions'](1) end,
--                {expr = true, remap = true})
-- vim.keymap.set('i', '<C-}>',
--                function() return vim.fn['codeium#CycleCompletions'](-1) end,
--                {expr = true, remap = true})
-- vim.keymap.set('i', '<C-?>', function() return vim.fn['codeium#Clear']() end,
--                {expr = true, remap = true})
--
map("n", "<leader>ga", [[:PhpactorGenerateAccessors<CR>]], mapopts)
map("n", "<leader>gs", [[:PhpactorGenerateMutators<CR>]], mapopts)

map("n", "<Esc>", "<Cmd>nohlsearch<CR>", mapopts)

-- neotest
vim.keymap.set("n", "<leader>tr", function()
	local nt = require("neotest")
	-- nt.summary.open()
	nt.output_panel.open()
	nt.output_panel.clear()
	nt.run.run(vim.fn.expand("%"))
end)

vim.keymap.set("n", "<leader>tt", function()
	local nt = require("neotest")
	nt.summary.toggle()
	nt.output_panel.toggle()
end)

vim.keymap.set("n", "<leader>tw", function()
	local nt = require("neotest")
	nt.watch.toggle()
end)

vim.keymap.set("n", "<leader>ta", function()
	local nt = require("neotest")
	nt.run.run("./tests")
end)
