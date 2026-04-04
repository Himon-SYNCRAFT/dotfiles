# Neovim Fresh Config — Design Spec
**Data:** 2026-04-03  
**Cel:** Przepisanie konfiguracji Neovim z `/home/himon/.config/nvim` do `/home/himon/.config/nvim-fresh` z wykorzystaniem wbudowanego package managera Neovim 0.12 (`vim.pack`) oraz natywnych możliwości LSP zamiast pluginów.

---

## Kontekst

Istniejąca konfiguracja w `~/.config/nvim` używa `lazy.nvim` jako package managera oraz kilku pluginów opakowujących funkcje LSP, które Neovim 0.12 oferuje natywnie. Celem jest:

1. Zastąpienie `lazy.nvim` wbudowanym `vim.pack`
2. Zastąpienie 4 pluginów LSP natywnymi odpowiednikami
3. Zachowanie 100% dotychczasowej funkcjonalności
4. Przeniesienie bindingów pluginów do ich własnych plików konfiguracyjnych

Baza: Neovim 0.12.0 + LuaJIT.

---

## Struktura plików

```
~/.config/nvim-fresh/
├── init.lua                  ← bootstrap vim.pack + opcje vim + require()
├── lua/
│   ├── pack.lua              ← NOWY: centralna lista vim.pack.add()
│   ├── plugins/
│   │   ├── lsp.lua           ← Mason + lspconfig + natywny lightbulb + natywna signature
│   │   ├── cmp.lua           ← nvim-cmp + wszystkie sources + bindingi completion menu
│   │   ├── codeium.lua       ← NOWY: codeium setup + binding <C-o>
│   │   ├── treesitter.lua    ← nvim-treesitter
│   │   ├── telescope.lua     ← telescope + extensions + WSZYSTKIE bindingi telescope
│   │   ├── conform.lua       ← conform + binding <space>f
│   │   ├── lint.lua          ← nvim-lint
│   │   ├── gitsigns.lua      ← gitsigns
│   │   ├── mini_files.lua    ← mini.files + bindingi F2/F3
│   │   ├── autosession.lua   ← auto-session + binding <leader>p
│   │   ├── theme.lua         ← kanagawa
│   │   ├── dadbod.lua        ← vim-dadbod + UI + completion + binding <leader>db
│   │   ├── kulala.lua        ← kulala.nvim
│   │   ├── lazydev.lua       ← lazydev.nvim
│   │   ├── luasnip.lua       ← LuaSnip + binding <C-K>
│   │   └── trouble.lua       ← trouble.nvim + WSZYSTKIE bindingi trouble
│   ├── user/
│   │   ├── luasnip/          ← bez zmian (php.lua, zig.lua, http.lua, go.lua)
│   │   └── telescope/        ← bez zmian (init.lua z project_files, find_configs, repo_list)
│   ├── statusline.lua        ← zaktualizowana: dodany vim.lsp.status()
│   ├── mappings.lua          ← tylko bindingi niezwiązane z pluginami
│   └── diagnostic.lua        ← bez zmian
├── after/
│   ├── ftplugin/             ← bez zmian (php.lua, c.lua, rust.lua, zig.lua, python.lua)
│   └── indent/               ← bez zmian (c.lua, yaml.lua, python.lua)
├── snippets/                 ← bez zmian (snipmate format)
└── colors/                   ← bez zmian (cyberpunk.vim, atom-dark-256.vim)
```

---

## vim.pack — zarządzanie pluginami

`lua/pack.lua` zawiera centralną listę wszystkich pluginów. `vim.pack.add()` pobiera plugin przy pierwszym uruchomieniu i dodaje go do runtimepath.

```lua
local function add(repo, opts)
    vim.pack.add("https://github.com/" .. repo, opts or {})
end

-- Zależności
add("nvim-lua/plenary.nvim")
add("nvim-tree/nvim-web-devicons")

-- LSP
add("neovim/nvim-lspconfig")
add("williamboman/mason.nvim")
add("williamboman/mason-lspconfig.nvim")
add("WhoIsSethDaniel/mason-tool-installer.nvim")

-- Completion
add("hrsh7th/nvim-cmp")
add("hrsh7th/cmp-nvim-lsp")
add("hrsh7th/cmp-buffer")
add("hrsh7th/cmp-path")
add("hrsh7th/cmp-cmdline")
add("L3MON4D3/LuaSnip")          -- build: "make install_jsregexp"
add("saadparwaiz1/cmp_luasnip")

-- Treesitter
add("nvim-treesitter/nvim-treesitter")  -- build: ":TSUpdate"

-- Telescope
add("nvim-telescope/telescope.nvim")
add("nvim-telescope/telescope-fzf-native.nvim")  -- build: "make"
add("nvim-telescope/telescope-file-browser.nvim")
add("cljoly/telescope-repo.nvim")

-- File explorer
add("echasnovski/mini.files")

-- Git
add("lewis6991/gitsigns.nvim")

-- Formatter + Linter
add("stevearc/conform.nvim")
add("mfussenegger/nvim-lint")

-- Diagnostics
add("folke/trouble.nvim")

-- Theme
add("rebelot/kanagawa.nvim")

-- Session
add("rmagatti/auto-session")

-- DB
add("tpope/vim-dadbod")
add("kristijanhusak/vim-dadbod-ui")
add("kristijanhusak/vim-dadbod-completion")

-- HTTP
add("mistweaverco/kulala.nvim")

-- Lua dev
add("folke/lazydev.nvim")

-- Editing helpers
add("tpope/vim-surround")
add("tpope/vim-repeat")
add("Raimondi/delimitMate")

-- AI
add("Exafunction/codeium.vim")

-- PHP
add("phpactor/phpactor")

-- Misc
add("joerdav/templ.vim")
```

**Uwaga:** Dokładne API `vim.pack` (obsługa `build`, opcje) zostanie zweryfikowane podczas implementacji w oparciu o `:help vim.pack` w Neovim 0.12.0.

**Kolejność require() w init.lua:**
```lua
require("pack")           -- najpierw — pobiera/rejestruje pluginy
require("plugins.theme")  -- theme przed innymi (floaty mają kolory)
require("plugins.lsp")
require("plugins.cmp")
require("plugins.luasnip")
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
require("plugins.codeium")
require("statusline")
require("mappings")
require("user.diagnostic")
```

---

## Natywne zastąpienia (usuwane pluginy)

### 1. `folke/lazy.nvim` → `vim.pack`
Zastąpiony kompletnie. Brak lazy-loading — wszystko ładuje się przy starcie.

### 2. `j-hui/fidget.nvim` → `vim.lsp.status()` w statusline

W `lua/statusline.lua` dodajemy funkcję LSP progress obok istniejącej funkcji `lsp()`:

```lua
local function lsp_progress()
    local status = vim.lsp.status()
    if status and status ~= "" then
        return " " .. status .. " "
    end
    return ""
end
```

Dodana do `Statusline.active()` obok istniejących komponentów.

### 3. `ray-x/lsp_signature.nvim` → autocmd w `lsp.lua`

W istniejącym autocmd `LspAttach` w `plugins/lsp.lua` dodajemy:

```lua
vim.api.nvim_create_autocmd("CursorHoldI", {
    buffer = args.buf,
    callback = function()
        vim.lsp.buf.signature_help({ border = "rounded" })
    end,
})
```

Rounded border zachowany — identyczny wygląd jak poprzednio.

### 4. `kosayoda/nvim-lightbulb` → autocmd + virtual text w `lsp.lua`

```lua
local lightbulb_ns = vim.api.nvim_create_namespace("lightbulb")

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
        local bufnr = vim.api.nvim_get_current_buf()
        vim.api.nvim_buf_clear_namespace(bufnr, lightbulb_ns, 0, -1)
        vim.lsp.buf_request(bufnr, "textDocument/codeAction",
            vim.lsp.util.make_range_params(),
            function(_, result)
                if result and #result > 0 then
                    vim.api.nvim_buf_set_extmark(bufnr, lightbulb_ns,
                        vim.fn.line(".") - 1, -1,
                        { virt_text = {{ " 󰌵", "DiagnosticHint" }},
                          virt_text_pos = "eol" })
                end
            end)
    end,
})
```

### 5. `stevearc/dressing.nvim` → natywne `vim.ui` w 0.12

Usuwany bez zastępnika — Neovim 0.12 poprawił natywne floaty dla `vim.ui.select` i `vim.ui.input`. Jeśli UI okaże się zbyt minimalistyczne w praktyce, plugin można przywrócić niezależnie.

---

## Organizacja bindingów klawiaturowych

**Zasada:** binding dotyczący pluginu mieszka w pliku konfiguracyjnym tego pluginu.

**`mappings.lua` zawiera wyłącznie:**
- Nawigacja splitów: `<C-h/j/k/l>`
- Terminal mode: `<esc><esc>` i `<C-h/j/k/l>` w trybie terminal
- Tworzenie splitów: `<leader>h`, `<leader>v`
- Wcięcia w visual: `<`, `>`
- Czyszczenie hlsearch: `<Esc>`
- Command abbreviations: `W!`, `Q!`, `Wq`, itd.
- Funkcja `open_terminal()` i binding `<leader>s`

**Przeniesione do plików pluginów:**
- `telescope.lua`: `gd`, `gi`, `gr`, `<leader>e`, `<leader>f`, `<leader>G`, `<leader>b`, `<leader>o`, `<leader>c`, `<leader>k`, `<leader>df`, `<leader>rl`, `<C-f>`, `<space>x`, `<space>h`, `<space>e`
- `trouble.lua`: `<leader>da`, `<leader>dg`, `<leader>de`, `<leader>cs`, `<leader>cl`, `<leader>dh`, `<leader>ds`
- `mini_files.lua`: `<F2>`, `<F3>`
- `autosession.lua`: `<leader>p`
- `dadbod.lua`: `<leader>db`
- `conform.lua`: `<space>f`
- `luasnip.lua`: `<C-K>`, `<Tab>`, `<S-Tab>` (snippet jump)
- `cmp.lua`: wszystkie mappings completion menu
- `lsp.lua`: `gD`, `K`, `<space>d`, `<leader>D`, `<leader>rn`, `<space><space>`, `<leader>ga`, `<leader>gs`
- `kulala.lua`: bindingi kulala (jeśli istnieją)
- `codeium.lua`: `<C-o>` insert mode (accept AI completion)

**Uwaga — bindingi do nieobecnych pluginów w oryginale:**  
`mappings.lua` w oryginalnej konfiguracji zawiera bindingi do `neotest` (`<leader>tr`, `<leader>tt`, `<leader>tw`, `<leader>ta`) i `obsidian` (`gf`), ale te pluginy nie są zadeklarowane w żadnym pliku pluginów. W nowej konfiguracji te bindingi są **pomijane** — jeśli pluginy mają być dodane, wymagają osobnych plików w `plugins/`.

---

## Pluginy zachowane bez zmian

| Plugin | Powód |
|---|---|
| `mason.nvim` + `mason-lspconfig` + `mason-tool-installer` | Instalacja LSP serverów — brak natywnego odpowiednika |
| `neovim/nvim-lspconfig` | Konfiguracja serverów LSP |
| `nvim-cmp` + sources | Completion z Codeium/snippetami/dadbod |
| `L3MON4D3/LuaSnip` | Snipmate format + custom snippets (vim.snippet nie wspiera snipmate) |
| `nvim-treesitter` | Zarządzanie parserami |
| `telescope.nvim` + extensions | Fuzzy finding — brak natywnego odpowiednika |
| `echasnovski/mini.files` | File explorer z podglądem |
| `lewis6991/gitsigns.nvim` | Git gutter |
| `stevearc/conform.nvim` | Formatowanie zewnętrznymi narzędziami |
| `mfussenegger/nvim-lint` | Linting (phpstan, phpcs, golangci-lint) |
| `rebelot/kanagawa.nvim` | Colorscheme |
| `rmagatti/auto-session` | Session management |
| `folke/trouble.nvim` | Diagnostics panel |
| `vim-dadbod` + UI + completion | DB client |
| `mistweaverco/kulala.nvim` | HTTP client |
| `folke/lazydev.nvim` | Lua LS workspace dla Neovim API |
| `tpope/vim-surround` + `vim-repeat` | Editing helpers |
| `Raimondi/delimitMate` | Auto-pairs |
| `Exafunction/codeium.vim` | AI completion |
| `phpactor/phpactor` | PHP refactoring |
| `joerdav/templ.vim` | Templ syntax |

---

## Weryfikacja

1. Uruchom `nvim` w `nvim-fresh` — pluginy pobrane przez `vim.pack`
2. Otwórz plik Go/PHP/Rust — LSP aktywny, inlay hints widoczne
3. Wpisz wywołanie funkcji — signature help pojawia się automatycznie (CursorHoldI)
4. Najedź na linię z code action — żarówka `󰌵` widoczna w virtual text
5. Statusline pokazuje postęp LSP podczas ładowania (zamiast fidget popup)
6. `<space><space>` otwiera code actions w float (nie dressing — natywne)
7. `<F2>` otwiera mini.files, `gd` otwiera telescope lsp_definitions
8. `<leader>da` otwiera trouble diagnostics
9. `<space>f` formatuje plik przez conform
10. Snippety działają: snipmate (`.snippets/`) + custom LuaSnip (`user/luasnip/`)
11. Codeium akceptowany przez `<C-o>` w insert mode
