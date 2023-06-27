-- LSP Server configurations.
local pylance = require('lsp.servers.pylance')

-- I must put here the enabling of the providers so that
-- if one is not avalaible then use fully the other ones.
vim.api.nvim_create_autocmd('FileType', {
    pattern = "python",
    callback = function()
        pylance.launch()
    end
})

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

local stop_lsp = function ()
    vim.lsp.stop_client(vim.lsp.get_active_clients())
end

vim.api.nvim_create_user_command('StopLSP', stop_lsp , {})
