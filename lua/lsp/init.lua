-- LSP Server configurations.
local jedi = require('lsp.servers.jedi')
local pyright = require('lsp.servers.pyright')
local pylance = require('lsp.servers.pylance')

-- I must put here the enabling of the providers so that
-- if one is not avalaible then use fully the other ones.
vim.api.nvim_create_autocmd('FileType', {
    pattern = "python",
    callback = function()
        -- jedi.launch()
        -- pyright.launch()
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

        -- vim.cmd([[
        -- augroup document_highlight
        -- autocmd!
        --     autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
        --     autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        -- augroup END
        -- ]])
    end,
})
