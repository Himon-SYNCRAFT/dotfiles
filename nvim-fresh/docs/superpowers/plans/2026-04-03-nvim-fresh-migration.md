# Neovim Fresh Config Migration — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Przepisać konfigurację Neovim z `~/.config/nvim` do `~/.config/nvim-fresh` używając wbudowanego `vim.pack` zamiast lazy.nvim i natywnych funkcji LSP zamiast 4 pluginów.

**Architecture:** Centralna lista pluginów w `lua/pack.lua` deklaruje wszystkie pluginy przez `vim.pack.add()`. Każdy plugin ma swój plik konfiguracyjny w `lua/plugins/` zawierający zarówno setup jak i keybindingi. `mappings.lua` zawiera wyłącznie bindingi niezwiązane z pluginami.

**Tech Stack:** Neovim 0.12.0, vim.pack (wbudowany), nvim-cmp, nvim-lspconfig, Mason, LuaSnip, Telescope, kanagawa.nvim

---

## Uwagi wstępne

**vim.pack API (Neovim 0.12):**
```lua
vim.pack.add({ 'https://github.com/user/repo', ... }, { confirm = false })
```
- Podczas `init.lua` `load` domyślnie = `false` — pluginy są dodawane do rtp ale pliki `plugin/` nie są auto-sourcowane. `require()` działa od razu po `add()`.
- Brak opcji `build` — kroki budowania (make, :TSUpdate) trzeba uruchomić ręcznie po pierwszej instalacji.
- Pluginy trafiają do `~/.local/share/nvim/site/pack/core/opt/`
- Lockfile: `~/.config/nvim-fresh/nvim-pack-lock.json`

**Kroki budowania po pierwszej instalacji (uruchomić raz ręcznie):**
```bash
# telescope-fzf-native
cd ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim && make

# LuaSnip (jsregexp support)
cd ~/.local/share/nvim/site/pack/core/opt/LuaSnip && make install_jsregexp
```
```
# nvim-treesitter — po pierwszym uruchomieniu nvim:
:TSUpdate
```

---

## Task 1: Inicjalizacja projektu + kopiowanie plików statycznych

**Files:**
- Create: `~/.config/nvim-fresh/` (directory structure)
- Create: `~/.config/nvim-fresh/lua/plugins/` (directory)
- Create: `~/.config/nvim-fresh/lua/user/` (directory)
- Copy: `snippets/`, `colors/`, `after/`

- [ ] **Krok 1: Zainicjalizuj git i stwórz strukturę katalogów**

```bash
cd ~/.config/nvim-fresh
git init
mkdir -p lua/plugins lua/user/luasnip lua/user/telescope after/ftplugin after/indent colors snippets docs/superpowers/plans docs/superpowers/specs
```

- [ ] **Krok 2: Skopiuj pliki statyczne**

```bash
# Snippets (snipmate format — bez zmian)
cp -r ~/.config/nvim/snippets/* ~/.config/nvim-fresh/snippets/

# Kolory
cp ~/.config/nvim/colors/cyberpunk.vim ~/.config/nvim-fresh/colors/
cp ~/.config/nvim/colors/atom-dark-256.vim ~/.config/nvim-fresh/colors/

# after/ftplugin
cp ~/.config/nvim/after/ftplugin/php.lua ~/.config/nvim-fresh/after/ftplugin/
cp ~/.config/nvim/after/ftplugin/c.lua ~/.config/nvim-fresh/after/ftplugin/
cp ~/.config/nvim/after/ftplugin/rust.lua ~/.config/nvim-fresh/after/ftplugin/
cp ~/.config/nvim/after/ftplugin/zig.lua ~/.config/nvim-fresh/after/ftplugin/
cp ~/.config/nvim/after/ftplugin/python.lua ~/.config/nvim-fresh/after/ftplugin/

# after/indent
cp ~/.config/nvim/after/indent/c.lua ~/.config/nvim-fresh/after/indent/
cp ~/.config/nvim/after/indent/yaml.lua ~/.config/nvim-fresh/after/indent/
cp ~/.config/nvim/after/indent/python.lua ~/.config/nvim-fresh/after/indent/

# LuaSnip custom snippets
cp ~/.config/nvim/lua/user/luasnip/php.lua ~/.config/nvim-fresh/lua/user/luasnip/
cp ~/.config/nvim/lua/user/luasnip/zig.lua ~/.config/nvim-fresh/lua/user/luasnip/
cp ~/.config/nvim/lua/user/luasnip/http.lua ~/.config/nvim-fresh/lua/user/luasnip/
cp ~/.config/nvim/lua/user/luasnip/go.lua ~/.config/nvim-fresh/lua/user/luasnip/
```

- [ ] **Krok 3: Commit**

```bash
cd ~/.config/nvim-fresh
git add .
git commit -m "chore: initial structure and static files"
```

---

## Task 2: lua/pack.lua — deklaracja pluginów

**Files:**
- Create: `lua/pack.lua`

- [ ] **Krok 1: Utwórz lua/pack.lua**

```lua
-- lua/pack.lua
-- Centralna lista pluginów zarządzanych przez vim.pack (wbudowany Neovim 0.12)
-- Pluginy trafiają do: ~/.local/share/nvim/site/pack/core/opt/
--
-- WAŻNE — kroki budowania po pierwszej instalacji (jednorazowe):
--   telescope-fzf-native:  cd ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim && make
--   LuaSnip jsregexp:      cd ~/.local/share/nvim/site/pack/core/opt/LuaSnip && make install_jsregexp
--   treesitter parsery:    :TSUpdate  (uruchomić z poziomu nvim)

vim.pack.add({
    -- Zależności
    'https://github.com/nvim-lua/plenary.nvim',
    'https://github.com/nvim-tree/nvim-web-devicons',

    -- LSP
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/williamboman/mason.nvim',
    'https://github.com/williamboman/mason-lspconfig.nvim',
    'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim',

    -- Completion
    'https://github.com/hrsh7th/nvim-cmp',
    'https://github.com/hrsh7th/cmp-nvim-lsp',
    'https://github.com/hrsh7th/cmp-buffer',
    'https://github.com/hrsh7th/cmp-path',
    'https://github.com/hrsh7th/cmp-cmdline',
    { src = 'https://github.com/L3MON4D3/LuaSnip', version = 'v2.*' },
    'https://github.com/saadparwaiz1/cmp_luasnip',

    -- Treesitter
    'https://github.com/nvim-treesitter/nvim-treesitter',

    -- Telescope
    'https://github.com/nvim-telescope/telescope.nvim',
    'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
    'https://github.com/nvim-telescope/telescope-file-browser.nvim',
    'https://github.com/cljoly/telescope-repo.nvim',

    -- File explorer
    'https://github.com/echasnovski/mini.files',

    -- Git
    'https://github.com/lewis6991/gitsigns.nvim',

    -- Formatter + Linter
    'https://github.com/stevearc/conform.nvim',
    'https://github.com/mfussenegger/nvim-lint',

    -- Diagnostics panel
    'https://github.com/folke/trouble.nvim',

    -- Theme
    'https://github.com/rebelot/kanagawa.nvim',

    -- Session
    'https://github.com/rmagatti/auto-session',

    -- DB
    'https://github.com/tpope/vim-dadbod',
    'https://github.com/kristijanhusak/vim-dadbod-ui',
    'https://github.com/kristijanhusak/vim-dadbod-completion',

    -- HTTP
    'https://github.com/mistweaverco/kulala.nvim',

    -- Lua dev
    'https://github.com/folke/lazydev.nvim',

    -- Editing helpers
    'https://github.com/tpope/vim-surround',
    'https://github.com/tpope/vim-repeat',
    'https://github.com/Raimondi/delimitMate',

    -- AI completion
    'https://github.com/Exafunction/codeium.vim',

    -- PHP
    'https://github.com/phpactor/phpactor',

    -- Misc
    'https://github.com/joerdav/templ.vim',
}, { confirm = false })
```

- [ ] **Krok 2: Commit**

```bash
cd ~/.config/nvim-fresh
git add lua/pack.lua
git commit -m "feat: add pack.lua with vim.pack plugin declarations"
```

---

## Task 3: init.lua — bootstrap i opcje

**Files:**
- Create: `init.lua`

- [ ] **Krok 1: Utwórz init.lua**

```lua
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

-- Pluginy muszą być załadowane przed konfiguracją
-- theme najpierw — żeby floaty i inne okna miały kolory
require("plugins.theme")
require("plugins.lsp")
require("plugins.cmp")
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
require("plugins.dadbod")
require("plugins.kulala")
require("plugins.lazydev")
require("statusline")
require("mappings")
require("user.diagnostic")

vim.cmd([[
    filetype plugin indent on
    set nocompatible

    set fileformats=unix,dos,mac
    set noswapfile

    syntax on
    set ruler
    set number
    set relativenumber
    set signcolumn=no
    set scrolloff=8

    let g:indentLine_loaded = 0

    set laststatus=3
    set cmdheight=0

    set backspace=indent,eol,start

    set tabstop=4
    set softtabstop=0
    set shiftwidth=4
    set expandtab
    set shiftround
    set nofoldenable

    set splitright
    set splitbelow

    set shortmess=filnxtToOFcsWAICS

    if has('unnamedplus')
        set clipboard=unnamed,unnamedplus
    endif

    set ignorecase
    set smartcase

    set completeopt=menu,menuone,noselect

    let g:codeium_no_map_tab = 1
    let g:codeium_filetypes = { "sql": v:false }

    let g:db_ui_auto_execute_table_helpers = 1
    let g:db_ui_table_helpers = {
    \   'postgresql': {
    \     'Count': 'SELECT count(*) FROM "{table}"',
    \     'Where': 'SELECT count(*) FROM "{table}" WHERE'
    \   },
    \   'sqlite': {
    \     'Count': 'SELECT count(*) FROM "{table}"',
    \     'Where': 'SELECT count(*) FROM "{table}" WHERE'
    \   },
    \   'mysql': {
    \     'Count': 'SELECT count(*) FROM "{table}"',
    \     'Where': 'SELECT count(*) FROM "{table}" WHERE'
    \   },
    \ }
]])
```

- [ ] **Krok 2: Weryfikacja — nvim startuje bez crash**

```bash
NVIM_APPNAME=nvim-fresh nvim --headless +qa 2>&1
```
Oczekiwane: brak błędów (pluginy mogą nie być jeszcze skonfigurowane, ale nie powinno być `module not found` dla pack.lua).

- [ ] **Krok 3: Commit**

```bash
cd ~/.config/nvim-fresh
git add init.lua
git commit -m "feat: add init.lua with vim.pack bootstrap and vim options"
```

---

## Task 4: lua/plugins/theme.lua — kanagawa

**Files:**
- Create: `lua/plugins/theme.lua`

- [ ] **Krok 1: Utwórz lua/plugins/theme.lua**

```lua
-- lua/plugins/theme.lua
require("kanagawa").setup({
    compile = false,
    undercurl = false,
    commentStyle = { italic = false },
    functionStyle = {},
    keywordStyle = { italic = false },
    statementStyle = { bold = true },
    typeStyle = { italic = false },
    transparent = true,
    dimInactive = false,
    terminalColors = true,
    colors = {
        palette = {},
        theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
    },
    theme = "wave",
    background = {
        dark = "wave",
        light = "lotus",
    },
    overrides = function(colors)
        local pallette = colors.palette
        local theme = colors.theme

        return {
            StatusLineNC = { fg = pallette.fujiWhite, bg = pallette.sumiInk0 },
            StatusLine = { fg = pallette.fujiWhite, bg = pallette.sumiInk4 },
            StatusLineErrSign = { fg = theme.diag.error, bg = pallette.sumiInk4 },
            StatusLineWarnSign = { fg = theme.diag.warning, bg = pallette.sumiInk4 },
            StatusLineHintSign = { fg = theme.diag.hint, bg = pallette.sumiInk4 },
            StatusLineInfoSign = { fg = theme.diag.info, bg = pallette.sumiInk4 },
            CursorLineNr = { fg = pallette.roninYellow, bg = pallette.sumiInk5 },
            ColorColumn = { bg = pallette.sumiInk4 },
            SignColumn = { bg = "None" },
            LineNr = { fg = pallette.sumiInk6, bg = "None" },
            TroubleLspFileName = { bg = "None", fg = pallette.fujiWhite },
            TroubleNormal = { bg = "None" },
            TroubleNormalNC = { bg = "None" },
            NormalFloat = { bg = "none" },
            FloatBorder = { bg = "none" },
            FloatTitle = { bg = "none" },
            NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
            LazyNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            MasonNormal = { bg = theme.ui.bg_m3, fg = theme.ui.fg_dim },
            ["@variable.builtin.php"] = { italic = false, fg = pallette.waveRed, bg = "none" },
        }
    end,
})

vim.fn.sign_define("DiagnosticSignError", { texthl = "DiagnosticSignError", text = "󰅙", numhl = "" })
vim.fn.sign_define("DiagnosticSignWarn",  { texthl = "DiagnosticSignWarn",  text = "󰀦", numhl = "" })
vim.fn.sign_define("DiagnosticSignHint",  { texthl = "DiagnosticSignHint",  text = "󰌵", numhl = "" })
vim.fn.sign_define("DiagnosticSignInfo",  { texthl = "DiagnosticSignInfo",  text = "󰀨", numhl = "" })

vim.opt.fillchars = "eob: ,vert: "

vim.cmd([[
    set termguicolors
    set noshowmode
    call matchadd('ColorColumn', '\%82v', 100)
    set winhighlight=Normal:ActiveWindow,NormalNC:InactiveWindow
    augroup CursorLine
        au!
        au VimEnter,WinEnter,BufWinEnter * setlocal cursorline
        au WinLeave * setlocal nocursorline
    augroup END
]])

vim.cmd("colorscheme kanagawa")
```

- [ ] **Krok 2: Weryfikacja**

```bash
NVIM_APPNAME=nvim-fresh nvim --headless +"colorscheme kanagawa" +qa 2>&1
```
Oczekiwane: brak błędów.

- [ ] **Krok 3: Commit**

```bash
git add lua/plugins/theme.lua
git commit -m "feat: add kanagawa theme config"
```

---

## Task 5: lua/plugins/lsp.lua — Mason + lspconfig + natywne zastąpienia

**Files:**
- Create: `lua/plugins/lsp.lua`

Zastępuje: `lsp_signature.nvim` (autocmd CursorHoldI), `nvim-lightbulb` (autocmd + virtual text).
Przenosi z mappings.lua: `gD`, `K`, `<space>d`, `<leader>D`, `<leader>rn`, `<space><space>`, `<leader>ga`, `<leader>gs`.

- [ ] **Krok 1: Utwórz lua/plugins/lsp.lua**

```lua
-- lua/plugins/lsp.lua
local util = require("lspconfig/util")
local lspconfig = require("lspconfig")

require("mason").setup({})
require("mason-tool-installer").setup({
    ensure_installed = {
        "emmet_language_server",
        "gofumpt",
        "goimports-reviser",
        "golangci-lint",
        "golines",
        "gopls",
        "intelephense",
        "kulala-fmt",
        "php-cs-fixer",
        "phpactor",
        "phpcs",
        "phpstan",
        "prettierd",
        "pyright",
        "rust-analyzer",
        "rustfmt",
        "sleek",
        "templ",
        "typescript-language-server",
        "yamlfmt",
    },
})
require("mason-lspconfig").setup({
    automatic_enable = false,
    automatic_installation = true,
    ensure_installed = {
        "emmet_language_server",
        "gopls",
        "intelephense",
        "phpactor",
        "pyright",
        "templ",
        "marksman",
    },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)

-- Natywna żarówka (zastępuje nvim-lightbulb)
local lightbulb_ns = vim.api.nvim_create_namespace("lightbulb")

local function update_lightbulb()
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_clear_namespace(bufnr, lightbulb_ns, 0, -1)
    vim.lsp.buf_request(bufnr, "textDocument/codeAction",
        vim.lsp.util.make_range_params(),
        function(_, result)
            if result and #result > 0 then
                vim.api.nvim_buf_set_extmark(bufnr, lightbulb_ns,
                    vim.fn.line(".") - 1, -1,
                    { virt_text = { { " 󰌵", "DiagnosticHint" } }, virt_text_pos = "eol" })
            end
        end)
end

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = update_lightbulb,
})

local handlers = {}

local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    -- LSP keybindings (przeniesione z mappings.lua)
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover({ border = "rounded" })
    end, bufopts)
    vim.keymap.set("n", "<space>d", vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
    vim.keymap.set("n", "<space><space>", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("v", "<space><space>", vim.lsp.buf.code_action, bufopts)
    vim.keymap.set("x", "<space><space>", vim.lsp.buf.code_action, bufopts)

    -- PHP-specific (przeniesione z mappings.lua)
    vim.keymap.set("n", "<leader>ga", ":PhpactorGenerateAccessors<CR>", bufopts)
    vim.keymap.set("n", "<leader>gs", ":PhpactorGenerateMutators<CR>", bufopts)

    if client.name == "intelephense" then
        client.server_capabilities.documentFormattingProvider = false
    end

    if client.server_capabilities.semanticTokensProvider
        and client.server_capabilities.semanticTokensProvider.full
    then
        vim.lsp.semantic_tokens.start(bufnr, client.id)
        vim.lsp.semantic_tokens.force_refresh()
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true)
        end

        -- Natywna signature help (zastępuje lsp_signature.nvim)
        vim.api.nvim_create_autocmd("CursorHoldI", {
            buffer = args.buf,
            callback = function()
                vim.lsp.buf.signature_help({ border = "rounded" })
            end,
        })
    end,
})

lspconfig.bashls.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
lspconfig.marksman.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
lspconfig.clangd.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
lspconfig.zls.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
lspconfig.kulala_ls.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
lspconfig.cssls.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })

lspconfig.intelephense.setup({
    init_options = {
        licenceKey = "/home/himon/intelephense/license.txt",
    },
    settings = {
        intelephense = {
            files = { maxSize = 4000000 },
            format = { enable = false },
        },
    },
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
})

lspconfig.gopls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_dir = util.root_pattern("go.work", "go.mod", ".git"),
    settings = {
        gopls = {
            completeUnimported = true,
            usePlaceholders = true,
            analyses = { unusedparams = true },
            ["formatting.gofumpt"] = true,
            ["ui.inlayhint.hints"] = {
                compositeLiteralFields = true,
                constantValues = true,
                parameterNames = true,
            },
        },
    },
})

lspconfig.templ.setup({ on_attach = on_attach, capabilities = capabilities, handlers = handlers })
lspconfig.jsonls.setup({ on_attach = on_attach, capabilities = capabilities })

local python_root_files = {
    "WORKSPACE", "pyproject.toml", "setup.py", "setup.cfg",
    "requirements.txt", "Pipfile", "pyrightconfig.json",
}

lspconfig.pyright.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = util.root_pattern(unpack(python_root_files)),
    handlers = handlers,
})

lspconfig.lua_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
        },
    },
})

lspconfig.rust_analyzer.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    settings = {
        ["rust-analyzer"] = {
            check = { command = "clippy" },
            diagnostics = { styleLints = { enable = true } },
        },
    },
})

lspconfig.ts_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers,
    filetypes = {
        "javascript", "javascriptreact", "javascript.jsx",
        "typescript", "typescriptreact", "typescript.tsx",
    },
    settings = {
        implicitProjectConfiguration = { checkJs = true },
    },
})

capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.emmet_language_server.setup({
    filetypes = {
        "css", "eruby", "html", "javascript", "javascriptreact",
        "less", "sass", "scss", "pug", "typescriptreact", "twig",
    },
    init_options = {
        includeLanguages = {},
        excludeLanguages = {},
        extensionsPath = {},
        preferences = {},
        showAbbreviationSuggestions = true,
        showExpandedAbbreviation = "always",
        showSuggestionsAsSnippets = false,
        syntaxProfiles = {},
        variables = {},
    },
})
```

- [ ] **Krok 2: Weryfikacja — LSP startuje na pliku Go**

```bash
NVIM_APPNAME=nvim-fresh nvim --headless +"lua print(vim.inspect(vim.lsp.get_clients()))" +qa 2>&1
```
Oczekiwane: brak błędów przy ładowaniu modułu.

- [ ] **Krok 3: Commit**

```bash
git add lua/plugins/lsp.lua
git commit -m "feat: add LSP config with native signature help and lightbulb"
```

---

## Task 6: lua/plugins/cmp.lua — nvim-cmp completion

**Files:**
- Create: `lua/plugins/cmp.lua`

- [ ] **Krok 1: Utwórz lua/plugins/cmp.lua**

```lua
-- lua/plugins/cmp.lua
local kind_icons = {
    Text = "", Method = "", Function = "󰊕", Constructor = "",
    Field = "󰭷", Variable = "󰫧", Class = "󰠱", Interface = "",
    Module = "", Property = "󰓹", Unit = "", Value = "󰎠",
    Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
    File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
    Constant = "󰏿", Struct = "", Event = "", Operator = "󱓉",
    TypeParameter = "", Codeium = "", Supermaven = "",
}

local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
    completion = {
        completeopt = "menu,menuone,fuzzy",
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)
            return vim_item
        end,
    },
    mapping = {
        ["<Down>"] = cmp.mapping(
            cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
            { "i" }
        ),
        ["<Up>"] = cmp.mapping(
            cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
            { "i" }
        ),
        ["<C-n>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
        }),
        ["<C-p>"] = cmp.mapping({
            i = function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
                else
                    fallback()
                end
            end,
        }),
        ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-4), { "i", "c" }),
        ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(4), { "i", "c" }),
        ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
        ["<C-e>"] = cmp.mapping({ i = cmp.mapping.close(), c = cmp.mapping.close() }),
        ["<CR>"] = cmp.mapping({
            i = cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Replace,
                select = false,
            }),
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(1) then
                luasnip.jump(1)
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = cmp.config.sources({
        { name = "lazydev", group_index = 0 },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "codeium", keyword_length = 2 },
        { name = "path" },
        { name = "vim-dadbod-completion" },
    }, { { name = "buffer", keyword_length = 5 } }),
})

local cmdline_mapping = {
    ["<C-n>"] = {
        c = function(fallback)
            if cmp.visible() then cmp.select_next_item() else fallback() end
        end,
    },
    ["<C-p>"] = {
        c = function(fallback)
            if cmp.visible() then cmp.select_prev_item() else fallback() end
        end,
    },
    ["<C-e>"] = { c = cmp.mapping.close() },
    ["<CR>"] = cmp.mapping({
        c = function(fallback)
            if cmp.get_selected_entry() == nil then
                cmp.mapping.close()
                fallback()
            elseif cmp.visible() then
                cmp.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = false })
            else
                fallback()
            end
        end,
    }),
}

cmp.setup.cmdline("/", {
    completion = { completeopt = "menu,menuone,fuzzy,noinsert,noselect" },
    mapping = cmdline_mapping,
    sources = { { name = "buffer", keyword_length = 5 } },
})

cmp.setup.cmdline(":", {
    mapping = cmdline_mapping,
    completion = { completeopt = "menu,menuone,noselect,fuzzy" },
    sources = cmp.config.sources(
        { { name = "path" } },
        { { name = "cmdline", keyword_length = 3 } }
    ),
})

vim.cmd([[
    autocmd FileType sql,mysql,plsql lua require('cmp').setup.buffer({ sources = {{ name = 'vim-dadbod-completion' }} })
    let g:completion_chain_complete_list = {
    \   'sql': [{'complete_items': ['vim-dadbod-completion']}],
    \ }
    let g:completion_matching_strategy_list = ['exact', 'substring']
    let g:completion_matching_ignore_case = 1
    let g:vim_dadbod_completion_mark = '󰆼'
]])
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/cmp.lua
git commit -m "feat: add nvim-cmp completion config"
```

---

## Task 7: lua/plugins/luasnip.lua — snippety

**Files:**
- Create: `lua/plugins/luasnip.lua`

- [ ] **Krok 1: Utwórz lua/plugins/luasnip.lua**

```lua
-- lua/plugins/luasnip.lua
local ls = require("luasnip")

ls.config.setup({
    enable_autosnippets = false,
})

-- Rozwinięcie snippetu
vim.keymap.set({ "i" }, "<C-K>", function()
    ls.expand()
end, { silent = true })

-- Ładowanie snippetów snipmate z katalogu snippets/
require("luasnip.loaders.from_snipmate").lazy_load()

-- Custom Lua snippets
require("user.luasnip.php")
require("user.luasnip.zig")
require("user.luasnip.http")
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/luasnip.lua
git commit -m "feat: add LuaSnip config with snipmate and custom snippets"
```

---

## Task 8: lua/plugins/codeium.lua — AI completion

**Files:**
- Create: `lua/plugins/codeium.lua`

- [ ] **Krok 1: Utwórz lua/plugins/codeium.lua**

```lua
-- lua/plugins/codeium.lua
-- Codeium inicjalizuje się przez vim.g zmienne ustawione w init.lua
-- (g:codeium_no_map_tab, g:codeium_filetypes)
-- Tutaj tylko keybinding accept

vim.keymap.set("i", "<C-o>", function()
    return vim.fn["codeium#Accept"]()
end, { expr = true })
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/codeium.lua
git commit -m "feat: add Codeium config with <C-o> accept binding"
```

---

## Task 9: lua/plugins/treesitter.lua — parsery

**Files:**
- Create: `lua/plugins/treesitter.lua`

- [ ] **Krok 1: Utwórz lua/plugins/treesitter.lua**

```lua
-- lua/plugins/treesitter.lua
require("nvim-treesitter.configs").setup({
    auto_install = true,
    ensure_installed = {
        "bash", "c", "cmake", "comment", "cpp", "css", "diff",
        "dockerfile", "dot", "fish", "go", "groovy", "html", "ini",
        "json", "lua", "make", "ocaml", "ocaml_interface", "php",
        "phpdoc", "python", "scss", "toml", "templ", "tsx", "twig",
        "typescript", "yaml", "markdown", "markdown_inline",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "markdown" },
    },
    indent = {
        enable = true,
        disable = { "python" },
    },
})
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/treesitter.lua
git commit -m "feat: add nvim-treesitter config"
```

---

## Task 10: lua/plugins/telescope.lua + lua/user/telescope/init.lua

**Files:**
- Create: `lua/plugins/telescope.lua`
- Create: `lua/user/telescope/init.lua`

Przenosi z mappings.lua: `gd`, `gi`, `gr`, `<leader>e`, `<leader>f`, `<leader>G`, `<leader>b`, `<leader>o`, `<leader>c`, `<leader>k`, `<leader>df`, `<leader>rl`, `<C-f>`, `<space>x`, `<space>h`, `<space>e`.

- [ ] **Krok 1: Utwórz lua/user/telescope/init.lua**

```lua
-- lua/user/telescope/init.lua
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local utils = require("telescope.utils")

local telescope_custom_actions = {}

function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = #picker:get_multi_selection()
    if not num_selections or num_selections <= 1 then
        actions.add_selection(prompt_bufnr)
    end
    actions.send_selected_to_qflist(prompt_bufnr)
    vim.cmd("cfdo " .. open_cmd)
end

function telescope_custom_actions.multi_selection_open(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

require("telescope").load_extension("file_browser")
require("telescope").load_extension("fzf")
require("telescope").load_extension("repo")

local M = {}

-- Eksponowane dla telescope.lua (custom multi-select)
local telescope_custom_actions = {}

local function grep_filtered(opts)
    opts = opts or {}
    require("telescope.builtin").grep_string({
        path_display = { "smart" },
        search = opts.filter_word or "",
    })
end

function M.grep_prompt()
    vim.ui.input({ prompt = "Rg " }, function(input)
        grep_filtered({ filter_word = input })
    end)
end

function M.grep_nvim_src()
    require("telescope.builtin").grep_string({
        results_title = "Neovim Source Code",
        path_display = { "smart" },
        search_dirs = {
            "~/vim-dev/sources/neovim/runtime/lua/vim/",
            "~/vim-dev/sources/neovim/src/nvim/",
        },
    })
end

M.project_files = function()
    local _, ret, _ = utils.get_os_command_output({ "git", "rev-parse", "--is-inside-work-tree" })

    local gopts = { show_untracked = true }
    local fopts = { "-L" }

    gopts.prompt_title = " Find"
    gopts.prompt_prefix = "  "
    gopts.results_title = " Repo Files"
    gopts.file_ignore_patterns = {
        "node_modules", "public/assets/js/vendor",
        ".woff", ".woff2", ".svg", ".eot", ".ttf",
        ".jpg", ".png", ".jpeg", ".nib", ".strings",
        ".gif", ".mp3", ".mp4", ".webm", ".icns",
    }

    fopts.hidden = true
    fopts.file_ignore_patterns = {
        ".vim/", ".local/", ".cache/", "Downloads/", ".git/",
        "Dropbox/.*", "Library/.*", ".rustup/.*", "Movies/",
        ".cargo/registry/", "~/Remote",
    }

    if ret == 0 then
        require("telescope.builtin").git_files(gopts)
    else
        fopts.results_title = "CWD: " .. vim.fn.getcwd()
        require("telescope.builtin").find_files(fopts)
    end
end

function M.find_configs()
    require("telescope.builtin").find_files({
        prompt_title = " NVim & Term Config Find",
        results_title = "Config Files Results",
        path_display = { "smart" },
        search_dirs = {
            "~/.config/fish/custom",
            "~/.config/nvim-fresh",
            "~/Projects/dotfiles",
        },
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.65, width = 0.75 },
    })
end

function M.nvim_config()
    require("telescope").extensions.file_browser.file_browser({
        prompt_title = " NVim Config Browse",
        cwd = "~/.config/nvim-fresh/",
        path_display = { shorten = { len = 1, exclude = { -1 } } },
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.65, width = 0.75 },
    })
end

function M.file_explorer()
    require("telescope").extensions.file_browser.file_browser({
        prompt_title = " File Browser",
        path_display = { "smart" },
        cwd = "~",
        layout_strategy = "horizontal",
        layout_config = { preview_width = 0.65, width = 0.75 },
    })
end

function M.repo_list()
    local opts = {}
    opts.prompt_title = " Repos"
    opts.file_ignore_patterns = {
        "^" .. vim.env.HOME .. "/%.cache/",
        "^" .. vim.env.HOME .. "/%.cargo/",
        "^" .. vim.env.HOME .. "/%.vim/",
        "^" .. vim.env.HOME .. "/%.config/",
        "^" .. vim.env.HOME .. "/%.local/",
    }
    require("telescope").extensions.repo.cached_list(opts)
end

-- Multiselect helpers (wywoływane z telescope.lua przez require("user.telescope").multi_selection_open)
function telescope_custom_actions._multiopen(prompt_bufnr, open_cmd)
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local picker = action_state.get_current_picker(prompt_bufnr)
    local num_selections = #picker:get_multi_selection()
    if not num_selections or num_selections <= 1 then
        actions.add_selection(prompt_bufnr)
    end
    actions.send_selected_to_qflist(prompt_bufnr)
    vim.cmd("cfdo " .. open_cmd)
end

M.multi_selection_open = function(prompt_bufnr)
    telescope_custom_actions._multiopen(prompt_bufnr, "edit")
end

return M
```

- [ ] **Krok 2: Utwórz lua/plugins/telescope.lua**

```lua
-- lua/plugins/telescope.lua
local actions = require("telescope.actions")
local mapopts = { noremap = true, silent = true }

require("telescope").setup({
    extensions = {
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
        },
        file_browser = { hidden = true },
    },
    defaults = {
        preview = { timeout = 500, msg_bg_fillchar = "" },
        multi_icon = " ",
        vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
        },
        prompt_prefix = "❯ ",
        selection_caret = "❯ ",
        sorting_strategy = "ascending",
        color_devicons = true,
        layout_config = {
            prompt_position = "bottom",
            horizontal = { width_padding = 0.04, height_padding = 0.1, preview_width = 0.6 },
            vertical = { width_padding = 0.05, height_padding = 1, preview_height = 0.5 },
        },
        mappings = {
            n = {
                ["<Del>"] = actions.close,
                ["<C-A>"] = function(pb)
                    require("user.telescope").multi_selection_open(pb)
                end,
            },
            i = {
                ["<esc>"] = actions.close,
                ["<C-A>"] = function(pb)
                    require("user.telescope").multi_selection_open(pb)
                end,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
        dynamic_preview_title = true,
    },
    pickers = {
        find_files = { follow = true },
    },
})

-- Ładowanie rozszerzeń (wywoływane z user/telescope/init.lua przez require)
require("user.telescope")

-- Keybindings telescope (przeniesione z mappings.lua)
local tb = require("telescope.builtin")
local ut = require("user.telescope")

-- LSP navigation
vim.keymap.set("n", "gd", function() tb.lsp_definitions() end, mapopts)
vim.keymap.set("n", "gi", function() tb.lsp_implementations() end, mapopts)
vim.keymap.set("n", "gr", function() tb.lsp_references() end, mapopts)

-- File finding
vim.keymap.set("n", "<leader>e", ut.project_files, mapopts)
vim.keymap.set("n", "<leader>df", function()
    tb.find_files({ find_command = { "fd", vim.fn.expand("<cword>") } })
end, mapopts)
vim.keymap.set("n", "<space>e", ut.find_configs, mapopts)

-- Search
vim.keymap.set("n", "<leader>f", "<Cmd>Telescope live_grep<CR>", mapopts)
vim.keymap.set("n", "<leader>G", function()
    tb.grep_string({ word_match = "-w" })
end, mapopts)
vim.keymap.set("n", "<C-f>", tb.current_buffer_fuzzy_find, mapopts)
vim.keymap.set("n", "<space>x", tb.diagnostics, mapopts)

-- Buffers & navigation
vim.keymap.set("n", "<leader>b", function()
    tb.buffers({
        prompt_title = "",
        results_title = "﬘",
        layout_strategy = "vertical",
        layout_config = { width = 0.40, height = 0.55 },
    })
end, mapopts)
vim.keymap.set("n", "<leader>o", function()
    tb.oldfiles({ results_title = "Recent-ish Files" })
end, mapopts)

-- Meta
vim.keymap.set("n", "<leader>c", function()
    tb.commands({ results_title = "Commands Results" })
end, mapopts)
vim.keymap.set("n", "<leader>k", function()
    tb.keymaps({ results_title = "Key Maps Results" })
end, mapopts)
vim.keymap.set("n", "<space>h", function()
    tb.help_tags({ results_title = "Help Results" })
end, mapopts)

-- Repos
vim.keymap.set("n", "<leader>rl", ut.repo_list, mapopts)
```

- [ ] **Krok 3: Commit**

```bash
git add lua/plugins/telescope.lua lua/user/telescope/init.lua
git commit -m "feat: add telescope config with all keybindings"
```

---

## Task 11: lua/plugins/mini_files.lua

**Files:**
- Create: `lua/plugins/mini_files.lua`

- [ ] **Krok 1: Utwórz lua/plugins/mini_files.lua**

```lua
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
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/mini_files.lua
git commit -m "feat: add mini.files config with F2/F3 bindings"
```

---

## Task 12: lua/plugins/gitsigns.lua

**Files:**
- Create: `lua/plugins/gitsigns.lua`

- [ ] **Krok 1: Utwórz lua/plugins/gitsigns.lua**

```lua
-- lua/plugins/gitsigns.lua
require("gitsigns").setup({
    signcolumn = false,
    numhl = false,
    linehl = false,
    word_diff = false,
    watch_gitdir = { interval = 1000, follow_files = true },
    attach_to_untracked = true,
    current_line_blame = false,
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = "eol",
        delay = 1000,
        ignore_whitespace = false,
    },
    current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil,
    max_file_length = 40000,
    preview_config = {
        border = "single",
        style = "minimal",
        relative = "cursor",
        row = 0,
        col = 1,
    },
})
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/gitsigns.lua
git commit -m "feat: add gitsigns config"
```

---

## Task 13: lua/plugins/conform.lua — formatowanie

**Files:**
- Create: `lua/plugins/conform.lua`

- [ ] **Krok 1: Utwórz lua/plugins/conform.lua**

```lua
-- lua/plugins/conform.lua
local conform = require("conform")

conform.setup({
    formatters = {
        kulala = {
            command = "kulala-fmt",
            args = { "format", "$FILENAME" },
            stdin = false,
        },
    },
    formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt", lsp_format = "fallback" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        go = { "goimports-reviser", "golines", "gofumpt" },
        php = { "php_cs_fixer" },
        c = { "clang-format" },
        templ = { "templ" },
        sql = { "sleek" },
        mysql = { "sleek" },
        html = { "prettierd", "prettier", stop_after_first = true },
        template = { "prettierd", "prettier", stop_after_first = true },
        http = { "kulala" },
    },
    format_on_save = {
        timeout_ms = 5000,
        lsp_format = "fallback",
    },
    notify_on_error = true,
    notify_no_formatters = true,
})

vim.keymap.set("n", "<space>f", function()
    conform.format({ async = false, timeout_ms = 10000, lsp_format = "fallback" })
end)
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/conform.lua
git commit -m "feat: add conform.nvim formatter config"
```

---

## Task 14: lua/plugins/lint.lua — linting

**Files:**
- Create: `lua/plugins/lint.lua`

- [ ] **Krok 1: Utwórz lua/plugins/lint.lua**

```lua
-- lua/plugins/lint.lua
local lint = require("lint")

lint.linters_by_ft = {
    php = { "phpstan", "phpcs" },
    go = { "golangcilint" },
}

local function debounce(ms, fn)
    local timer = vim.uv.new_timer()
    return function(...)
        local argv = { ... }
        timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
        end)
    end
end

local function do_lint()
    local names = lint._resolve_linter_by_ft(vim.bo.filetype)
    names = vim.list_extend({}, names)

    if #names == 0 then
        vim.list_extend(names, lint.linters_by_ft["_"] or {})
    end
    vim.list_extend(names, lint.linters_by_ft["*"] or {})

    local ctx = { filename = vim.api.nvim_buf_get_name(0) }
    ctx.dirname = vim.fn.fnamemodify(ctx.filename, ":h")
    names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
            vim.print("Linter not found: " .. name, { title = "nvim-lint" })
        end
        return linter and not (type(linter) == "table" and linter.condition and not linter.condition(ctx))
    end, names)

    if #names > 0 then
        lint.try_lint(names)
    end
end

vim.api.nvim_create_autocmd(
    { "BufWritePost", "BufReadPost", "TextChanged", "TextChangedI" },
    {
        group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
        callback = debounce(100, do_lint),
    }
)
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/lint.lua
git commit -m "feat: add nvim-lint config"
```

---

## Task 15: lua/plugins/trouble.lua — diagnostics panel

**Files:**
- Create: `lua/plugins/trouble.lua`

Przenosi z mappings.lua: `<leader>da`, `<leader>dg`, `<leader>de`, `<leader>cs`, `<leader>cl`, `<leader>dh`, `<leader>ds`.

- [ ] **Krok 1: Utwórz lua/plugins/trouble.lua**

```lua
-- lua/plugins/trouble.lua
require("trouble").setup({})

local mapopts = { noremap = true, silent = true }

vim.keymap.set("n", "<leader>da", "<cmd>Trouble diagnostics toggle<cr>", mapopts)
vim.keymap.set("n", "<leader>dg", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", mapopts)
vim.keymap.set("n", "<leader>de",
    "<cmd>Trouble diagnostics toggle filter = { buf = 0, severity = vim.diagnostic.severity.ERROR }<cr>",
    mapopts)
vim.keymap.set("n", "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", mapopts)
vim.keymap.set("n", "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", mapopts)
vim.keymap.set("n", "<leader>dh", "[[<Cmd>lua vim.diagnostic.disable()<CR>]]", mapopts)
vim.keymap.set("n", "<leader>ds", "[[<Cmd>lua vim.diagnostic.enable()<CR>]]", mapopts)
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/trouble.lua
git commit -m "feat: add trouble.nvim config with diagnostic keybindings"
```

---

## Task 16: lua/plugins/autosession.lua

**Files:**
- Create: `lua/plugins/autosession.lua`

Przenosi z mappings.lua: `<leader>p`.

- [ ] **Krok 1: Utwórz lua/plugins/autosession.lua**

```lua
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
    require("auto-session.session-lens").search_session,
    { noremap = true, silent = true })
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/autosession.lua
git commit -m "feat: add auto-session config with <leader>p binding"
```

---

## Task 17: lua/plugins/dadbod.lua — database UI

**Files:**
- Create: `lua/plugins/dadbod.lua`

Przenosi z mappings.lua: `<leader>db`.

- [ ] **Krok 1: Utwórz lua/plugins/dadbod.lua**

```lua
-- lua/plugins/dadbod.lua
-- vim-dadbod, vim-dadbod-ui i vim-dadbod-completion są deklarowane w pack.lua
-- Konfiguracja globalna jest w init.lua (g:db_ui_table_helpers, g:db_ui_auto_execute_table_helpers)

vim.keymap.set("n", "<leader>db", ":DBUIToggle<CR>", { noremap = true, silent = true })
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/dadbod.lua
git commit -m "feat: add dadbod config with <leader>db binding"
```

---

## Task 18: lua/plugins/kulala.lua — HTTP client

**Files:**
- Create: `lua/plugins/kulala.lua`

- [ ] **Krok 1: Utwórz lua/plugins/kulala.lua**

```lua
-- lua/plugins/kulala.lua
require("kulala").setup({
    global_keymaps = true,
    global_keymaps_prefix = "<space>r",
    kulala_keymaps_prefix = "",
})
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/kulala.lua
git commit -m "feat: add kulala.nvim HTTP client config"
```

---

## Task 19: lua/plugins/lazydev.lua — Lua dev

**Files:**
- Create: `lua/plugins/lazydev.lua`

- [ ] **Krok 1: Utwórz lua/plugins/lazydev.lua**

```lua
-- lua/plugins/lazydev.lua
require("lazydev").setup({
    library = {
        { path = "luvit-meta/library", words = { "vim%.uv" } },
    },
})
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/lazydev.lua
git commit -m "feat: add lazydev.nvim Lua workspace config"
```

---

## Task 20: lua/statusline.lua — z vim.lsp.status()

**Files:**
- Create: `lua/statusline.lua`

Zastępuje fidget.nvim przez `vim.lsp.status()`.

- [ ] **Krok 1: Utwórz lua/statusline.lua**

```lua
-- lua/statusline.lua
local modes = {
    ["n"] = "NORMAL", ["no"] = "NORMAL", ["v"] = "VISUAL",
    ["V"] = "VISUAL LINE", [""] = "VISUAL BLOCK", ["s"] = "SELECT",
    ["S"] = "SELECT LINE", [""] = "SELECT BLOCK", ["i"] = "INSERT",
    ["ic"] = "INSERT", ["R"] = "REPLACE", ["Rv"] = "VISUAL REPLACE",
    ["c"] = "COMMAND", ["cv"] = "VIM EX", ["ce"] = "EX",
    ["r"] = "PROMPT", ["rm"] = "MOAR", ["r?"] = "CONFIRM",
    ["!"] = "SHELL", ["t"] = "TERMINAL",
}

local function mode()
    local current_mode = vim.api.nvim_get_mode().mode
    return string.format(" %s ", modes[current_mode] or current_mode):upper()
end

local function filepath()
    local fpath = vim.fn.fnamemodify(vim.fn.expand("%"), ":~:.:h")
    if fpath == "" or fpath == "." then return " " end
    return string.format(" %%<%s/", fpath)
end

local function filename()
    local fname = vim.fn.expand("%:t")
    if fname == "" then fname = "- No Name -" end
    if vim.bo.modifiable == false or vim.bo.readonly then
        fname = "󰌾 " .. fname
    end
    if vim.bo.modified then
        fname = "󰧞 " .. fname
    end
    return " " .. fname .. " "
end

local function lsp_progress()
    -- Natywne zastąpienie fidget.nvim
    local status = vim.lsp.status()
    if status and status ~= "" then
        return " " .. status .. " "
    end
    return ""
end

local function lsp()
    local count = {}
    local levels = { errors = "Error", warnings = "Warn", info = "Info", hints = "Hint" }
    for k, level in pairs(levels) do
        count[k] = vim.tbl_count(vim.diagnostic.get(0, { severity = level }))
    end
    return
        " %#StatusLineErrSign#󰅙 " .. count["errors"] ..
        " %#StatusLineWarnSign#󰀦 " .. count["warnings"] ..
        " %#StatusLineInfoSign#󰀨 " .. count["info"] ..
        " %#StatusLineHintSign#󰌵 " .. count["hints"]
end

local function lineinfo()
    if vim.bo.filetype == "alpha" then return "" end
    return " %l/%L: %c "
end

Statusline = {}

Statusline.active = function()
    return table.concat({
        "%#Statusline#",
        mode(),
        lsp_progress(),
        lsp(),
        " ",
        "%#Statusline#",
        filename(),
        "%=%#StatusLine#",
        lineinfo(),
    })
end

function Statusline.inactive()
    return " %F"
end

vim.api.nvim_exec([[
    augroup Statusline
    au!
    au WinEnter,BufEnter * setlocal statusline=%!v:lua.Statusline.active()
    au WinLeave,BufLeave * setlocal statusline=%!v:lua.Statusline.inactive()
    augroup END
]], false)
```

- [ ] **Krok 2: Commit**

```bash
git add lua/statusline.lua
git commit -m "feat: add statusline with native vim.lsp.status() replacing fidget.nvim"
```

---

## Task 21: lua/mappings.lua — tylko non-plugin bindingi

**Files:**
- Create: `lua/mappings.lua`

Tylko bindingi niezwiązane z pluginami — bez telescope, trouble, mini.files, auto-session, dadbod, codeium, phpactor.

- [ ] **Krok 1: Utwórz lua/mappings.lua**

```lua
-- lua/mappings.lua
-- Wyłącznie bindingi niezwiązane z pluginami.
-- Bindingi pluginów są w ich własnych plikach lua/plugins/*.lua

local map = vim.api.nvim_set_keymap
local mapopts = { noremap = true, silent = true }

-- Command abbreviations
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

-- Nawigacja splitów
map("n", "<C-j>", "<C-w>j", mapopts)
map("n", "<C-k>", "<C-w>k", mapopts)
map("n", "<C-l>", "<C-w>l", mapopts)
map("n", "<C-h>", "<C-w>h", mapopts)

-- Terminal mode — wyjście i nawigacja splitów
map("t", "<esc><esc>", "<C-\\><C-n>", mapopts)
map("t", "<C-j>", "<C-\\><C-n><C-w>j", mapopts)
map("t", "<C-k>", "<C-\\><C-n><C-w>k", mapopts)
map("t", "<C-l>", "<C-\\><C-n><C-w>l", mapopts)
map("t", "<C-h>", "<C-\\><C-n><C-w>h", mapopts)

-- Tworzenie splitów
map("n", "<leader>h", ":<C-u>split<CR>", mapopts)
map("n", "<leader>v", ":<C-u>vsplit<CR>", mapopts)

-- Wcięcia w visual mode
map("v", "<", "<gv", mapopts)
map("v", ">", ">gv", mapopts)

-- Czyszczenie highlight po wyszukiwaniu
map("n", "<Esc>", "<Cmd>nohlsearch<CR>", mapopts)

-- Terminal: otwórz terminal w małym splicie poniżej, cd do katalogu projektu
local function vimdir()
    local workspace_folders = vim.lsp.buf.list_workspace_folders()
    if workspace_folders and #workspace_folders > 0 then
        return workspace_folders[1]
    end
    return vim.fn.expand("%:p:h")
end

local function open_terminal()
    vim.cmd(string.format("let $VIM_DIR = '%s'", vimdir()))
    vim.cmd("10split")
    vim.cmd("terminal fish")
    vim.api.nvim_input("Acd $VIM_DIR<cr>clear<cr>")
    vim.cmd("se winfixheight")
end

vim.keymap.set("n", "<leader>s", open_terminal, mapopts)
```

- [ ] **Krok 2: Commit**

```bash
git add lua/mappings.lua
git commit -m "feat: add mappings.lua with only non-plugin keybindings"
```

---

## Task 22: lua/user/diagnostic.lua

**Files:**
- Create: `lua/user/diagnostic.lua`

init.lua wywołuje `require("user.diagnostic")` — plik musi być w `lua/user/diagnostic.lua`.

- [ ] **Krok 1: Utwórz lua/user/diagnostic.lua**

```lua
-- lua/user/diagnostic.lua
vim.diagnostic.config({
    signs = {
        numhl = {
            [vim.diagnostic.severity.WARN] = "WarningMsg",
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticHint",
        },
    },
    underline = false,
    virtual_text = true,
})
```

- [ ] **Krok 2: Commit**

```bash
git add lua/user/diagnostic.lua
git commit -m "feat: add diagnostic config"
```

---

## Task 23: Weryfikacja końcowa i kroki budowania

**Files:** brak zmian w plikach

- [ ] **Krok 1: Uruchom nvim-fresh po raz pierwszy (instalacja pluginów)**

```bash
NVIM_APPNAME=nvim-fresh nvim
```
Oczekiwane: vim.pack pobiera wszystkie pluginy. Może pojawić się prompt — zaakceptuj.

- [ ] **Krok 2: Uruchom kroki budowania (jednorazowe)**

```bash
# telescope-fzf-native
cd ~/.local/share/nvim/site/pack/core/opt/telescope-fzf-native.nvim && make

# LuaSnip
cd ~/.local/share/nvim/site/pack/core/opt/LuaSnip && make install_jsregexp
```

```
# W nvim-fresh:
:TSUpdate
```

- [ ] **Krok 3: Test — LSP działa**

```
# Otwórz plik Go:
NVIM_APPNAME=nvim-fresh nvim /tmp/test.go
```
Oczekiwane: gopls uruchamia się, inlay hints widoczne, `K` pokazuje hover z rounded border.

- [ ] **Krok 4: Test — signature help**

Wpisz wywołanie funkcji w pliku Go/PHP i wstrzymaj się chwilę w insert mode.
Oczekiwane: pojawia się float z signature help (rounded border).

- [ ] **Krok 5: Test — lightbulb**

Najedź na linię z dostępną code action.
Oczekiwane: `󰌵` widoczny w virtual text na końcu linii.

- [ ] **Krok 6: Test — statusline z LSP progress**

Podczas ładowania LSP statusline pokazuje tekst postępu (zamiast fidget popup w rogu).

- [ ] **Krok 7: Test — telescope**

```
<leader>e  → project files
gd         → lsp definitions (telescope)
<leader>f  → live grep
```

- [ ] **Krok 8: Test — snippety**

Otwórz plik PHP, wpisz nazwę snippetu z `snippets/php.snippets`, rozwiń przez `<C-K>`.

- [ ] **Krok 9: Test — formatowanie**

Otwórz plik Go. `<space>f` formatuje przez gofumpt/goimports-reviser/golines.

- [ ] **Krok 10: Test — trouble**

`<leader>da` otwiera Trouble diagnostics toggle.

- [ ] **Krok 11: Commit końcowy**

```bash
cd ~/.config/nvim-fresh
git add nvim-pack-lock.json
git commit -m "chore: add nvim-pack lockfile after initial install"
```
