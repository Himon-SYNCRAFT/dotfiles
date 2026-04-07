# Design: blink.cmp migration + init.lua native Lua refactor

**Data:** 2026-04-07  
**Zakres:** Zastąpienie nvim-cmp przez blink.cmp oraz konwersja vim.cmd w init.lua na natywne Lua.

---

## 1. Zmiany w pluginach (`pack.lua`)

### Usunąć
- `hrsh7th/nvim-cmp`
- `hrsh7th/cmp-nvim-lsp`
- `hrsh7th/cmp-buffer`
- `hrsh7th/cmp-path`
- `hrsh7th/cmp-cmdline`
- `saadparwaiz1/cmp_luasnip`

### Dodać
- `saghen/blink.cmp` — główny silnik completion
- `saghen/blink.compat` — wrapper dla vim-dadbod-completion

### Bez zmian
- `L3MON4D3/LuaSnip` — blink ma natywne wsparcie LuaSnip
- `kristijanhusak/vim-dadbod-completion` — działa przez blink.compat
- `Exafunction/codeium.vim` — inline ghost text, `<C-o>` niezmieniony
- Cała reszta pluginów

---

## 2. Konfiguracja completion (`cmp.lua` → `blink.lua`)

Plik `lua/plugins/cmp.lua` zostaje przemianowany na `lua/plugins/blink.lua`.  
W `init.lua` zmiana: `require("plugins.cmp")` → `require("plugins.blink")`.

### Źródła (w kolejności priorytetu)
```lua
{ name = "lazydev",  group_index = 0 }   -- built-in blink preset
{ name = "lsp" }                          -- built-in
{ name = "luasnip" }                      -- built-in
{ name = "path" }                         -- built-in
{ name = "dadbod" }                       -- via blink.compat (vim-dadbod-completion)
{ name = "buffer",   min_keyword_length = 5 }  -- built-in
```

Codeium NIE jest źródłem completion — użytkownik korzysta wyłącznie z inline ghost text przez `<C-o>`.

### Klawisze (insert mode) — zachowane 1:1
| Klawisz | Akcja |
|---|---|
| `<Down>` | select_next (Select behavior) |
| `<Up>` | select_prev (Select behavior) |
| `<C-n>` | select_next (Insert behavior) — tylko gdy lista widoczna |
| `<C-p>` | select_prev (Insert behavior) — tylko gdy lista widoczna |
| `<C-b>` | scroll dokumentacji w górę |
| `<C-f>` | scroll dokumentacji w dół |
| `<C-Space>` | wymuś pokazanie completion |
| `<C-e>` | zamknij completion |
| `<CR>` | potwierdź (Replace, select=false — nie akceptuje pierwszego bez wyboru) |
| `<Tab>` | LuaSnip jump forward (jeśli jumpable) |
| `<S-Tab>` | LuaSnip jump backward (jeśli jumpable) |

### Cmdline
- `/` — źródło: buffer (min_keyword_length=5), fuzzy, noinsert noselect
- `:` — źródła: path, cmdline (min_keyword_length=3), noselect, fuzzy
- Klawisze cmdline: `<C-n>`, `<C-p>`, `<C-e>`, `<CR>` (z logiką: nie potwierdza jeśli nic nie zaznaczone)

### SQL/dadbod autocmd
Przeniesiony z VimL do natywnego Lua. W blink per-buffer sources konfiguruje się przez opcję `sources.per_filetype` w głównym setupie blink:
```lua
sources = {
    per_filetype = {
        sql   = { "dadbod" },
        mysql = { "dadbod" },
        plsql = { "dadbod" },
    },
    ...
}
```
Eliminuje potrzebę autocmd dla SQL.

### Globals dadbod (z bloku vim.cmd w cmp.lua)
Konwersja z VimL na `vim.g.*`:
```lua
vim.g.completion_chain_complete_list = { sql = { { complete_items = { "vim-dadbod-completion" } } } }
vim.g.completion_matching_strategy_list = { "exact", "substring" }
vim.g.completion_matching_ignore_case = 1
vim.g.vim_dadbod_completion_mark = "󰆼"
```

### Wygląd
- Okno completion i dokumentacji: zaokrąglone obramowanie (border = "rounded")
- Kind icons: zachowana obecna mapa ikon Nerd Font

---

## 3. LSP capabilities (`lsp.lua`)

Zastąpić pobieranie capabilities:

```lua
-- PRZED
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, cmp = pcall(require, "cmp_nvim_lsp")
if ok then
    capabilities = cmp.default_capabilities(capabilities)
end
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- PO
local capabilities = require("blink.cmp").get_lsp_capabilities()
```

`get_lsp_capabilities()` blink automatycznie zawiera snippetSupport. Reszta `lsp.lua` bez zmian.

---

## 4. Refactoring `init.lua` — vim.cmd → native Lua

### Usunąć (no-op lub zastąpione przez treesitter/Neovim defaults)
- `set nocompatible` — no-op w Neovim
- `syntax on` — usunięte (treesitter przejmuje podświetlanie)

### Konwersja opcji

| VimL | Lua |
|---|---|
| `filetype plugin indent on` | `vim.cmd("filetype plugin indent on")` (jedno zdanie) |
| `set fileformats=unix,dos,mac` | `vim.o.fileformats = "unix,dos,mac"` |
| `set noswapfile` | `vim.o.swapfile = false` |
| `set ruler` | `vim.o.ruler = true` |
| `set number` | `vim.o.number = true` |
| `set relativenumber` | `vim.o.relativenumber = true` |
| `set signcolumn=no` | `vim.o.signcolumn = "no"` |
| `set scrolloff=8` | `vim.o.scrolloff = 8` |
| `set laststatus=3` | `vim.o.laststatus = 3` |
| `set cmdheight=0` | `vim.o.cmdheight = 0` |
| `set backspace=indent,eol,start` | `vim.o.backspace = "indent,eol,start"` |
| `set tabstop=4` | `vim.o.tabstop = 4` |
| `set softtabstop=0` | `vim.o.softtabstop = 0` |
| `set shiftwidth=4` | `vim.o.shiftwidth = 4` |
| `set expandtab` | `vim.o.expandtab = true` |
| `set shiftround` | `vim.o.shiftround = true` |
| `set nofoldenable` | `vim.o.foldenable = false` |
| `set splitright` | `vim.o.splitright = true` |
| `set splitbelow` | `vim.o.splitbelow = true` |
| `set shortmess=filnxtToOFcsWAICS` | `vim.o.shortmess = "filnxtToOFcsWAICS"` |
| `if has('unnamedplus') ... clipboard` | `vim.o.clipboard = "unnamed,unnamedplus"` (has() zawsze true w Neovim) |
| `set ignorecase` | `vim.o.ignorecase = true` |
| `set smartcase` | `vim.o.smartcase = true` |
| `set completeopt=menu,menuone,noselect` | usunięte — blink zarządza completeopt |
| `set updatetime=300` | `vim.o.updatetime = 300` |

### Globals — konwersja

```lua
-- codeium (zostaje w init.lua, przeniesione z vim.cmd)
vim.g.codeium_no_map_tab = 1
vim.g.codeium_filetypes = { sql = false }

-- indentLine
vim.g.indentLine_loaded = 0

-- dadbod globals (przenoszone do blink.lua)
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

`vim.g.db_ui_*` przenoszone do nowego pliku `lua/plugins/dadbod.lua`, a `init.lua` dostaje `require("plugins.dadbod")`.

---

## 5. Pliki dotknięte przez implementację

| Plik | Zmiana |
|---|---|
| `lua/pack.lua` | Usuń cmp-*, dodaj blink.cmp + blink.compat |
| `lua/plugins/cmp.lua` | Przemianować na `blink.lua`, przepisać na blink API |
| `lua/plugins/lsp.lua` | Zmień capabilities na blink |
| `init.lua` | vim.cmd → native Lua, zmień require cmp→blink |
| `lua/plugins/dadbod.lua` | Nowy plik — `vim.g.db_ui_*` globals przeniesione z `init.lua` |
| `lua/plugins/codeium.lua` | Bez zmian |
| `lua/plugins/luasnip.lua` | Bez zmian |

---

## 6. Ryzyko i uwagi

- **blink.cmp cmdline API** — API dla cmdline w blink może różnić się od cmp; wymaga weryfikacji podczas implementacji.
- **blink.compat dla dadbod** — source name w blink.compat to `"vim-dadbod-completion"`, ale może wymagać aliasu `"dadbod"`.
- **blink.cmp version** — użyć stabilnej wersji (tag), nie `main`, dla `vim.pack` z polem `version`.
- **lazydev preset** — `lazydev.nvim` ma dedykowany preset dla blink, nie wymaga blink.compat.
