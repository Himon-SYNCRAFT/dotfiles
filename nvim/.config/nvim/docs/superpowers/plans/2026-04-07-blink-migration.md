# Blink.cmp Migration + init.lua Native Lua Refactor — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Zastąpić nvim-cmp przez blink.cmp z zachowaniem wszystkich klawiszy i źródeł, oraz skonwertować blok `vim.cmd` w `init.lua` na natywne Lua.

**Architecture:** Pięć plików ulega zmianie: `pack.lua` (zamiana pluginów), `init.lua` (native Lua + nowe require), `lsp.lua` (capabilities z blink), `cmp.lua` → usunięty, nowy `blink.lua`. Tworzony jest też `dadbod.lua` przenoszący globals db_ui z `init.lua`. `blink.compat` obsługuje `vim-dadbod-completion`. `codeium.vim` i `plugins/codeium.lua` pozostają bez zmian.

**Tech Stack:** Neovim 0.12+, blink.cmp v1.*, blink.compat v2.*, LuaSnip v2, vim-dadbod-completion, lazydev.nvim

---

## Mapa plików

| Plik | Operacja |
|---|---|
| `lua/pack.lua` | Modyfikacja — usuń cmp-*, dodaj blink.cmp + blink.compat |
| `lua/plugins/dadbod.lua` | Utwórz — `vim.g.db_ui_*` globals przeniesione z `init.lua` |
| `init.lua` | Modyfikacja — vim.cmd → native Lua, usuń db_ui globals, zmień require cmp→blink, dodaj require dadbod |
| `lua/plugins/lsp.lua` | Modyfikacja — capabilities z blink zamiast cmp_nvim_lsp |
| `lua/plugins/blink.lua` | Utwórz — pełna konfiguracja blink.cmp |
| `lua/plugins/cmp.lua` | Usuń |

---

## Task 1: Zaktualizuj pack.lua

**Files:**
- Modify: `lua/pack.lua`

- [ ] **Krok 1: Usuń pluginy nvim-cmp i codeium.vim, dodaj blink**

Otwórz `lua/pack.lua`. Znajdź sekcję `-- Completion` i zastąp ją całą poniższą zawartością (usuń też `codeium.vim` z sekcji `-- AI completion`):

```lua
	-- Completion
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.*" },
	{ src = "https://github.com/saghen/blink.compat", version = "v2.*" },
	{ src = "https://github.com/L3MON4D3/LuaSnip", version = "v2.4.1" },
```

Usuń te linie (tylko cmp-*, NIE codeium.vim — zostaje):
```
"https://github.com/hrsh7th/nvim-cmp",
"https://github.com/hrsh7th/cmp-nvim-lsp",
"https://github.com/hrsh7th/cmp-buffer",
"https://github.com/hrsh7th/cmp-path",
"https://github.com/hrsh7th/cmp-cmdline",
"https://github.com/saadparwaiz1/cmp_luasnip",
```

`codeium.vim` pozostaje w pack.lua — jest wymagany przez `plugins/codeium.lua` (`codeium#Accept()`).

- [ ] **Krok 2: Zweryfikuj składnię**

```bash
nvim --headless -c "lua require('pack')" -c "q" 2>&1 | head -20
```

Oczekiwane: brak błędów Lua (ostrzeżenia o brakujących pluginach do zainstalowania są OK).

- [ ] **Krok 3: Commit**

```bash
git add lua/pack.lua
git commit -m "feat: replace nvim-cmp with blink.cmp in pack.lua"
```

---

## Task 2: Utwórz lua/plugins/dadbod.lua

**Files:**
- Create: `lua/plugins/dadbod.lua`

- [ ] **Krok 1: Utwórz plik z globals db_ui**

Zawartość `lua/plugins/dadbod.lua`:

```lua
-- lua/plugins/dadbod.lua
vim.g.db_ui_auto_execute_table_helpers = 1
vim.g.db_ui_table_helpers = {
    postgresql = {
        Count = 'SELECT count(*) FROM "{table}"',
        Where  = 'SELECT count(*) FROM "{table}" WHERE',
    },
    sqlite = {
        Count = 'SELECT count(*) FROM "{table}"',
        Where  = 'SELECT count(*) FROM "{table}" WHERE',
    },
    mysql = {
        Count = 'SELECT count(*) FROM "{table}"',
        Where  = 'SELECT count(*) FROM "{table}" WHERE',
    },
}
```

- [ ] **Krok 2: Commit**

```bash
git add lua/plugins/dadbod.lua
git commit -m "feat: extract dadbod globals to plugins/dadbod.lua"
```

---

## Task 3: Refaktoring init.lua

**Files:**
- Modify: `init.lua`

- [ ] **Krok 1: Zastąp cały blok vim.cmd natywnym Lua**

Znajdź blok zaczynający się od `vim.cmd([[` (linia ~37) i kończący się na `]])` (linia ~99). Zastąp go całością poniżej:

```lua
vim.cmd("filetype plugin indent on")

vim.o.fileformats  = "unix,dos,mac"
vim.o.swapfile     = false

vim.o.ruler        = true
vim.o.number       = true
vim.o.relativenumber = true
vim.o.signcolumn   = "no"
vim.o.scrolloff    = 8

vim.g.indentLine_loaded = 0

vim.o.laststatus   = 3
vim.o.cmdheight    = 0

vim.o.backspace    = "indent,eol,start"

vim.o.tabstop      = 4
vim.o.softtabstop  = 0
vim.o.shiftwidth   = 4
vim.o.expandtab    = true
vim.o.shiftround   = true
vim.o.foldenable   = false

vim.o.splitright   = true
vim.o.splitbelow   = true

vim.o.shortmess    = "filnxtToOFcsWAICS"
vim.o.clipboard    = "unnamed,unnamedplus"

vim.o.ignorecase   = true
vim.o.smartcase    = true

vim.o.updatetime   = 300

vim.g.codeium_no_map_tab  = 1
vim.g.codeium_filetypes   = { sql = false }
```

- [ ] **Krok 2: Zaktualizuj listę require**

Zmień:
```lua
require("plugins.cmp")
```
na:
```lua
require("plugins.blink")
require("plugins.dadbod")
```

Usuń `require("plugins.codeium")` z listy — ta konfiguracja (keymap `<C-o>`) będzie przeniesiona do `plugins/codeium.lua`, który już istnieje i jest ładowany osobno. Sprawdź czy `require("plugins.codeium")` jest w pliku — jeśli tak, zostaw je (plik `codeium.lua` nadal musi być załadowany).

Jeśli w `init.lua` był `require("plugins.codeium")`, zostaje bez zmian.

- [ ] **Krok 3: Usuń linie db_ui globals z init.lua**

Usuń linie:
```lua
let g:db_ui_auto_execute_table_helpers = 1
let g:db_ui_table_helpers = { ... }
```
(Są teraz w `plugins/dadbod.lua`, który jest ładowany przez `require("plugins.dadbod")`.)

Uwaga: te linie były wewnątrz bloku `vim.cmd([[...]])`, który właśnie zastąpiłeś w kroku 1 — więc nie ma ich już do usunięcia osobno.

- [ ] **Krok 4: Sprawdź składnię pliku**

```bash
nvim --headless -c "luafile init.lua" -c "q" 2>&1 | head -20
```

Oczekiwane: brak błędów Lua.

- [ ] **Krok 5: Commit**

```bash
git add init.lua
git commit -m "refactor: convert vim.cmd block to native Lua in init.lua"
```

---

## Task 4: Zaktualizuj capabilities w lsp.lua

**Files:**
- Modify: `lua/plugins/lsp.lua:31-37`

- [ ] **Krok 1: Zastąp capabilities z cmp_nvim_lsp na blink**

Znajdź fragment (linia ~31):
```lua
-- capabilities (cmp)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp = pcall(require, "cmp_nvim_lsp")
if ok then
    capabilities = cmp.default_capabilities(capabilities)
end

capabilities.textDocument.completion.completionItem.snippetSupport = true
```

Zastąp go:
```lua
-- capabilities (blink)
local capabilities = require("blink.cmp").get_lsp_capabilities()
```

`get_lsp_capabilities()` automatycznie zawiera snippetSupport i resztę potrzebnych capabilities.

- [ ] **Krok 2: Sprawdź składnię**

```bash
nvim --headless -c "lua require('plugins.lsp')" -c "q" 2>&1 | head -20
```

Oczekiwane: brak błędów.

- [ ] **Krok 3: Commit**

```bash
git add lua/plugins/lsp.lua
git commit -m "feat: use blink.cmp capabilities in lsp.lua"
```

---

## Task 5: Utwórz lua/plugins/blink.lua

**Files:**
- Create: `lua/plugins/blink.lua`

To jest główny task — pełna konfiguracja blink.cmp zastępująca `cmp.lua`.

- [ ] **Krok 1: Utwórz plik lua/plugins/blink.lua**

```lua
-- lua/plugins/blink.lua
local luasnip = require("luasnip")

local kind_icons = {
    Text = "", Method = "", Function = "󰊕", Constructor = "",
    Field = "󰭷", Variable = "󰫧", Class = "󰠱", Interface = "",
    Module = "", Property = "󰓹", Unit = "", Value = "󰎠",
    Enum = "", Keyword = "󰌋", Snippet = "", Color = "󰏘",
    File = "󰈙", Reference = "", Folder = "󰉋", EnumMember = "",
    Constant = "󰏿", Struct = "", Event = "", Operator = "󱓉",
    TypeParameter = "",
}

require("blink.compat").setup()

require("blink.cmp").setup({

    snippets = { preset = "luasnip" },

    -- ========================
    -- Klawisze (insert mode)
    -- ========================
    keymap = {
        preset = "none",
        -- Down/Up = Select behavior (podświetla, nie wstawia tekstu)
        ["<Down>"]    = { "select_next", "fallback" },
        ["<Up>"]      = { "select_prev", "fallback" },
        -- C-n/C-p = tylko gdy lista widoczna
        ["<C-n>"]     = {
            function(cmp)
                if cmp.is_visible() then return cmp.select_next() end
            end,
            "fallback",
        },
        ["<C-p>"]     = {
            function(cmp)
                if cmp.is_visible() then return cmp.select_prev() end
            end,
            "fallback",
        },
        -- Scroll dokumentacji
        ["<C-b>"]     = { "scroll_documentation_up", "fallback" },
        ["<C-f>"]     = { "scroll_documentation_down", "fallback" },
        -- Pokaż / zamknij
        ["<C-Space>"] = { "show", "fallback" },
        ["<C-e>"]     = { "cancel", "fallback" },
        -- CR: potwierdź tylko gdy coś jest zaznaczone (select = false)
        ["<CR>"]      = {
            function(cmp)
                if cmp.is_visible() and cmp.get_selected_item() ~= nil then
                    return cmp.accept({ behavior = "replace" })
                end
            end,
            "fallback",
        },
        -- Tab/S-Tab: tylko LuaSnip jumping
        ["<Tab>"]     = {
            function(_cmp)
                if luasnip.locally_jumpable(1) then
                    luasnip.jump(1)
                    return true
                end
            end,
            "fallback",
        },
        ["<S-Tab>"]   = {
            function(_cmp)
                if luasnip.locally_jumpable(-1) then
                    luasnip.jump(-1)
                    return true
                end
            end,
            "fallback",
        },
    },

    -- ========================
    -- Wygląd
    -- ========================
    appearance = {
        kind_icons = kind_icons,
    },

    -- ========================
    -- Źródła
    -- ========================
    sources = {
        default = { "lazydev", "lsp", "snippets", "path", "dadbod", "buffer" },
        per_filetype = {
            sql   = { "dadbod" },
            mysql = { "dadbod" },
            plsql = { "dadbod" },
        },
        providers = {
            lazydev = {
                name         = "LazyDev",
                module       = "lazydev.integrations.blink",
                score_offset = 100,
            },
            buffer = {
                min_keyword_length = 5,
            },
            cmdline = {
                min_keyword_length = 3,
            },
            dadbod = {
                name   = "dadbod",
                module = "blink.compat.source",
                opts   = { cmp_name = "vim-dadbod-completion" },
            },
        },
    },

    -- ========================
    -- Completion menu
    -- ========================
    completion = {
        menu = {
            border = "rounded",
            draw = {
                columns = {
                    { "kind_icon" },
                    { "label", "label_description", gap = 1 },
                },
                components = {
                    kind_icon = {
                        text = function(ctx)
                            return (kind_icons[ctx.kind] or "") .. " "
                        end,
                    },
                },
            },
        },
        documentation = {
            auto_show = true,
            window    = { border = "rounded" },
        },
        -- Nie preselektuje pierwszego elementu; CR nie akceptuje bez wyboru
        list = {
            selection = { preselect = false, auto_insert = false },
        },
    },

    -- ========================
    -- Cmdline
    -- ========================
    cmdline = {
        enabled = true,
        keymap  = {
            preset  = "none",
            ["<C-n>"] = { "select_next", "fallback" },
            ["<C-p>"] = { "select_prev", "fallback" },
            ["<C-e>"] = { "cancel", "fallback" },
            -- CR: nie akceptuje gdy nic nie zaznaczone
            ["<CR>"]  = {
                function(cmp)
                    if cmp.is_visible() and cmp.get_selected_item() ~= nil then
                        return cmp.accept()
                    end
                end,
                "fallback",
            },
        },
        -- Źródła per typ cmdline
        sources = function()
            local type = vim.fn.getcmdtype()
            if type == "/" or type == "?" then
                return { "buffer" }
            elseif type == ":" or type == "@" then
                return { "path", "cmdline" }
            end
            return {}
        end,
        completion = {
            menu = { auto_show = true },
            list = { selection = { preselect = false, auto_insert = false } },
        },
    },
})

-- Globals vim-dadbod-completion (compat z pluginem)
vim.g.completion_chain_complete_list = {
    sql = { { complete_items = { "vim-dadbod-completion" } } },
}
vim.g.completion_matching_strategy_list = { "exact", "substring" }
vim.g.completion_matching_ignore_case = 1
vim.g.vim_dadbod_completion_mark = "󰆼"
```

- [ ] **Krok 2: Sprawdź składnię**

```bash
nvim --headless -c "lua require('plugins.blink')" -c "q" 2>&1 | head -20
```

Oczekiwane: brak błędów Lua (błędy o brakujących pluginach są OK przed `:PackInstall`).

- [ ] **Krok 3: Commit**

```bash
git add lua/plugins/blink.lua
git commit -m "feat: add blink.cmp configuration"
```

---

## Task 6: Usuń stary cmp.lua

**Files:**
- Delete: `lua/plugins/cmp.lua`

- [ ] **Krok 1: Usuń plik**

```bash
rm /home/himon/.config/nvim-fresh/lua/plugins/cmp.lua
```

- [ ] **Krok 2: Commit**

```bash
git add -u lua/plugins/cmp.lua
git commit -m "chore: remove old nvim-cmp configuration"
```

---

## Task 7: Zainstaluj pluginy i weryfikacja

**Files:** brak zmian w plikach

- [ ] **Krok 1: Uruchom Neovim i zainstaluj nowe pluginy**

Uruchom nvim, następnie wykonaj komendę instalacji przez wbudowany manager:

```
:PackInstall
```

Poczekaj na zakończenie instalacji blink.cmp i blink.compat.

- [ ] **Krok 2: Sprawdź brak błędów przy starcie**

Uruchom nvim ponownie i sprawdź czy nie ma błędów:

```bash
nvim --headless -c "checkhealth blink" -c "q" 2>&1
```

Oczekiwane: sekcja blink.cmp bez ERROR.

- [ ] **Krok 3: Weryfikuj LSP completion**

Otwórz dowolny plik `.go` lub `.lua`, wpisz kilka liter i sprawdź:
- Pojawia się okno completion z ikonami kind
- `<Down>`/`<Up>` nawigują bez wstawiania tekstu
- `<C-n>`/`<C-p>` nawigują tylko gdy lista jest widoczna
- `<CR>` nie akceptuje gdy nic nie zaznaczone (wstawia newline)
- `<CR>` akceptuje gdy element jest zaznaczony przez `<Down>`
- `<C-e>` zamyka listę

- [ ] **Krok 4: Weryfikuj LuaSnip**

W pliku PHP lub innym z snippetami wpisz trigger snippeta, sprawdź:
- `<Tab>` skacze do następnego pola
- `<S-Tab>` skacze do poprzedniego pola

- [ ] **Krok 5: Weryfikuj cmdline**

W trybie `:` wpisz kilka liter — sprawdź czy pojawia się completion. Naciśnij `<C-n>`/`<C-p>` do nawigacji, `<CR>` do akceptacji.

- [ ] **Krok 6: Weryfikuj codeium ghost text**

Otwórz plik i sprawdź czy ghost text Codeium pojawia się, a `<C-o>` go akceptuje.

- [ ] **Krok 7: Weryfikuj dadbod (jeśli masz DB)**

W pliku `.sql` sprawdź czy pojawia się completion z vim-dadbod-completion.

- [ ] **Krok 8: Commit końcowy (jeśli były poprawki)**

```bash
git add -A
git commit -m "fix: post-migration tweaks after verification"
```

---

## Uwagi implementacyjne

- **blink.cmp v1.* wymaga blink.compat v2.*** — wersje w `pack.lua` muszą być zgodne.
- **`snippets` nie `luasnip`** w `sources.default` — blink używa nazwy `"snippets"` dla wbudowanego źródła snippetów, nie `"luasnip"`.
- **`cmp_name` w dadbod provider** — `opts.cmp_name = "vim-dadbod-completion"` jest nazwą źródła dla nvim-cmp; `name = "dadbod"` to nazwa używana w blink.
- **`codeium.vim` + blink.cmp** — nie kolidują bo codeium używa virtualtext niezależnie od popup completion. `g:codeium_no_map_tab = 1` zapobiega konfliktom klawiszowym.
- **`lazydev` preset** — moduł `"lazydev.integrations.blink"` jest dostarczany przez `lazydev.nvim` natywnie, nie wymaga blink.compat.
