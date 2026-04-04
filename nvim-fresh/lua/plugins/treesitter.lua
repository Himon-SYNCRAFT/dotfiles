-- lua/plugins/treesitter.lua
-- nvim-treesitter (nowe API — Neovim 0.12 / nvim-treesitter rewrite)
-- Stare: require("nvim-treesitter.configs").setup({}) → usunięte
-- Nowe: require("nvim-treesitter").install({...}), vim.treesitter.start()

local parsers = {
    "bash", "c", "cmake", "comment", "cpp", "css", "diff",
    "dockerfile", "dot", "fish", "go", "groovy", "html", "ini",
    "json", "lua", "make", "ocaml", "ocaml_interface", "php",
    "phpdoc", "python", "scss", "toml", "templ", "tsx", "twig",
    "typescript", "yaml", "markdown", "markdown_inline",
}

-- Zainstaluj parsery jeśli nie są zainstalowane (asynchronicznie)
require("nvim-treesitter").install(parsers)

-- Highlight: włącz dla każdego filetype (built-in vim.treesitter)
vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- Indentacja przez nvim-treesitter (eksperymentalna)
-- Wyjątki: python używa własnej indentacji
vim.api.nvim_create_autocmd("FileType", {
    pattern = {
        "bash", "c", "cmake", "cpp", "css", "dockerfile",
        "go", "html", "json", "lua", "php", "scss",
        "toml", "tsx", "typescript", "yaml",
    },
    callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
