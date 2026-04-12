-- init.lua
vim.g.mapleader = ","
vim.o.background = "dark"
vim.o.sessionoptions = "buffers,curdir,folds,tabpages,winsize,winpos"

vim.filetype.add({
	pattern = {
		["%.env%.[%w_.-]+"] = "sh",
	},
})

-- Bootstrap: pobiera/rejestruje wszystkie pluginy
require("pack")

-- theme najpierw — żeby floaty i inne okna miały kolory
require("plugins.theme")
require("plugins.mini_notify")
require("plugins.mini_pairs")
require("plugins.mini_surround")
require("plugins.lsp")
require("plugins.blink")
require("plugins.dadbod")
require("plugins.luasnip")
require("plugins.codeium")
require("plugins.treesitter")
require("plugins.telescope")
require("plugins.mini_files")
require("plugins.gitsigns")
require("plugins.conform")
require("plugins.lint")
require("plugins.trouble")
require("plugins.autosession")
require("plugins.kulala")
require("plugins.lazydev")
require("statusline")
require("mappings")
require("user.diagnostic")
require("plugins.lightbulb").setup()

vim.cmd("filetype plugin indent on")

vim.o.fileformats = "unix,dos,mac"
vim.o.swapfile = false
vim.o.backup = false
vim.o.writebackup = false
vim.o.undofile = true
vim.o.undodir = os.getenv("HOME") .. "/.vim/undodir"

vim.o.ruler = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "no"
vim.o.scrolloff = 8

vim.g.indentLine_loaded = 0

vim.o.laststatus = 3
vim.o.cmdheight = 0

vim.o.backspace = "indent,eol,start"

vim.o.tabstop = 4
vim.o.softtabstop = 0
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.shiftround = true
vim.o.foldenable = false

vim.o.splitright = true
vim.o.splitbelow = true

vim.o.shortmess = "filnxtToOFcsWAICS"
vim.o.clipboard = "unnamed,unnamedplus"

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.hlsearch = true
vim.o.incsearch = true

vim.o.updatetime = 300
vim.o.synmaxcol = 300

vim.g.codeium_no_map_tab = 1
vim.g.codeium_filetypes = { sql = false }

vim.o.winborder = "rounded"
vim.o.pumborder = "rounded"
