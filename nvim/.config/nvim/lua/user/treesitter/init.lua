require("nvim-treesitter.configs").setup {
    ensure_installed = {
        'bash', 'c', 'cmake', 'comment', 'commonlisp', 'cpp', 'css', 'diff',
        'dockerfile', 'dot', 'elixir', 'elm', 'erlang', 'fennel', 'fish', 'go',
        'groovy', 'html', 'ini', 'json', 'lua', 'make', 'ocaml',
        'ocaml_interface', 'ocamllex', 'org', 'php', 'phpdoc', 'python', 'scss',
        'toml', 'tsx', 'twig', 'typescript', 'yaml', 'yuck', 'markdown',
        'markdown_inline' -- , 'javascript',
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

    rainbow = {enable = false, extended_mode = true, max_file_lines = nil}
}
