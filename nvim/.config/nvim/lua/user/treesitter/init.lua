require("nvim-treesitter.configs").setup {
    ensure_installed = {
        'bash', 'c', 'cmake', 'comment', 'commonlisp', 'cpp', 'css', 'diff',
        'dockerfile', 'dot', 'elixir', 'elm', 'erlang', 'fennel', 'fish',
        'gleam', 'go', 'groovy', 'haskell', 'html', 'ini', 'javascript', 'json',
        'lua', 'make', 'norg', 'ocaml', 'ocaml_interface', 'ocamllex', 'org',
        'php', 'phpdoc', 'python', 'rust', 'scss', 'toml', 'tsx', 'twig',
        'typescript', 'vim', 'vimdoc', 'yaml', 'yuck', 'zig', 'markdown',
        'markdown_inline'
    },

    highlight = {
        enable = true,
        additional_vim_regex_highlighting = {'org', 'markdown'}
    },

    indent = {
        enable = true,
        -- enable = false,
        disable = {"python"}
    },

    rainbow = {enable = true, extended_mode = true, max_file_lines = nil}
}
