vim.cmd [[
    set completeopt=menu,menuone,noselect
]]

require("nvim-lsp-installer").setup {automatic_installation = true}

local lspconfig = require("lspconfig")
local lsp_signature = require("lsp_signature")

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp
                                                                      .protocol
                                                                      .make_client_capabilities())

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = {noremap = true, silent = true, buffer = bufnr}
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
    vim.keymap
        .set('v', '<space><space>', vim.lsp.buf.range_code_action, bufopts)
    vim.keymap
        .set('x', '<space><space>', vim.lsp.buf.range_code_action, bufopts)
    -- vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<space>f', vim.lsp.buf.format, bufopts)

    lsp_signature.on_attach({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {border = "rounded"}
    }, bufnr)
end

lspconfig.bashls.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.cssls.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.elmls.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.tailwindcss.setup {on_attach = on_attach, capabilities = capabilities}

-- lspconfig.gradlels.setup {}
lspconfig.groovyls.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.hls.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.html.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.intelephense.setup {
    init_options = {licenceKey = "/home/himon/intelephense/license.txt"},
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.jdtls.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.kotlin_language_server.setup {
    on_attach = on_attach,
    capabilities = capabilities
}

lspconfig.metals.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.jsonls.setup {on_attach = on_attach, capabilities = capabilities}

local python_root_files = {
    'WORKSPACE', -- added for Bazel; items below are from default config
    'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile',
    'pyrightconfig.json'
}

lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    root_dit = lspconfig.util.root_pattern(unpack(python_root_files))
}

lspconfig.sqlls.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.sumneko_lua.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.tsserver.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.vimls.setup {on_attach = on_attach, capabilities = capabilities}

lspconfig.emmet_ls.setup({
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = {
        'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss',
        'less', 'twig'
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
