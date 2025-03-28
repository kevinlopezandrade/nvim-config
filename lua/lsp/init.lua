-- LSP Server configurations.

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local opts = { buffer = args.buf, silent = true }
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', '<C-K>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', 'R', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
        vim.keymap.set('n', '<leader>lc', vim.lsp.buf.incoming_calls, opts)
        vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format, opts)
    end,
})

local settings = {
    basedpyright = {
        disableOrganizeImports = true,
        analysis = {
            useLibraryCodeForTypes = true, -- I can test this manually.
            typeCheckingMode = "strict"
        }
    },
    telemetry = {
        telemetryLevel = "off",
    }
}

vim.lsp.config['basedpyright'] = {
    name = "basedpyright",
    cmd = {"basedpyright-langserver", "--stdio"},
    settings = settings,
    root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml', "environment.yml"}, { upward = true})[1]),
    filetypes = {"python"},
}

vim.lsp.enable('basedpyright')
