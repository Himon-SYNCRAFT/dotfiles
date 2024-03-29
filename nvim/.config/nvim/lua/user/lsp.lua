vim.cmd [[
    set completeopt=menu,menuone,noselect
]]

require("mason").setup {}
require("mason-lspconfig").setup({
    automatic_installation = true,
    ensured_installed = {
        'emmet_ls', 'gofumpt', 'goimports-reviser', 'golines', 'gopls',
        'intelephense', 'php-cs-fixer', 'phpactor', 'phpcs', 'phpstan',
        'pyright', 'templ', 'tsserver'
    }
})

local util = require("lspconfig/util")
local lspconfig = require("lspconfig")
local lsp_signature = require("lsp_signature")

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
    .protocol
    .make_client_capabilities())
local border = {
    { "┌", "FloatBorder" }, { "─", "FloatBorder" }, { "┐", "FloatBorder" },
    { "│", "FloatBorder" }, { "┘", "FloatBorder" }, { "─", "FloatBorder" },
    { "└", "FloatBorder" }, { "│", "FloatBorder" }

}

local handlers = {
    ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover,
        { border = border })
    -- ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers
    --                                                   .signature_help,
    --                                               {border = border})
}

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }

    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    -- vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<space>d', vim.lsp.buf.signature_help, bufopts)
    -- vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- vim.keymap.set('n', '<space>wl', function()
    --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<space><space>', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('v', '<space><space>', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('x', '<space><space>', vim.lsp.buf.code_action, bufopts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)

    -- lsp_signature.on_attach({
    --     bind = true, -- This is mandatory, otherwise border config won't get registered.
    --     handler_opts = {border = "rounded"}
    -- }, bufnr)
end

-- TODO: może to się przyda
-- require("mason-lspconfig").setup_handlers {
--     function(server_name)
--         require("lspconfig")[server_name].setup {
--             on_attach = on_attach,
--             capabilities = capabilities,
--             handlers = handlers
--         }
--     end
-- }

lspconfig.bashls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.cssls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.tailwindcss.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

-- lspconfig.groovyls.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     handlers = handlers
-- }

-- lspconfig.jdtls.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     handlers = handlers,
--     filetypes = {
--         "java", "groovy"
--     }
-- }

-- lspconfig.html.setup {
--     on_attach = on_attach,
--     capabilities = capabilities,
--     handlers = handlers,
--     init_options = {provideFormatter = false}
-- }

lspconfig.intelephense.setup {
    init_options = { licenceKey = "/home/himon/intelephense/license.txt" },
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.phpactor.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.gopls.setup {
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
            ["formatting.gofumpt"] = true
        }
    }
}

lspconfig.ocamllsp.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.templ.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.jsonls.setup { on_attach = on_attach, capabilities = capabilities }

local python_root_files = {
    'WORKSPACE', -- added for Bazel; items below are from default config
    'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile',
    'pyrightconfig.json'
}

lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dir = util.root_pattern(unpack(python_root_files)),
    handlers = handlers
}

lspconfig.sqlls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.sqls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.lua_ls.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

lspconfig.tsserver.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    handlers = handlers
}

capabilities.textDocument.completion.completionItem.snippetSupport = true

lspconfig.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
        "css", "eruby", "html", "javascript", "javascriptreact", "less", "sass",
        "scss", "svelte", "pug", "typescriptreact", "vue", "twig"
    },
    init_options = {
        html = {
            options = {
                -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                ["bem.enabled"] = true
            }
        }
    }
})

vim.lsp.handlers["textDocument/hover"] =
    vim.lsp.with(vim.lsp.handlers.hover, { focusable = false })

vim.cmd [[
" Here we configure Ionide-vim.
function! s:fsharp()
    " Required: to be used with nvim-cmp.
    let g:fsharp#lsp_auto_setup = 0

    " Recommended: show tooptip when you hold cursor over something for 1 second.
    if has('nvim') && exists('*nvim_open_win')
        set updatetime=2000
        augroup FSharpShowTooltip
            autocmd!
            autocmd CursorHold *.fs,*.fsi,*.fsx call fsharp#showTooltip()
        augroup END
    endif

    " Recommended: Paket files are excluded from the project loader.
    let g:fsharp#exclude_project_directories = ['paket-files']
endfunction

let g:fsharp#fsautocomplete_command = 'fsautocomplete'


" Finally, we call each functions.
call s:fsharp()
]]
