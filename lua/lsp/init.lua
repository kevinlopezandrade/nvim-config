-- LSP Server configurations.
local conform = require("conform")
conform.setup({
    formatters_by_ft = {
        python = {
            -- To run the Ruff formatter.
            "ruff_format",
            -- To organize the imports.
            "ruff_organize_imports",
        },
    },
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
        vim.keymap.set('n', '<leader>lf', conform.format, opts)
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

-- Basedpyright
vim.lsp.config['basedpyright'] = {
    name = "basedpyright",
    cmd = {"basedpyright-langserver", "--stdio"},
    settings = settings,
    root_markers = { {'pyproject.toml', 'setup.py'}, '.git' },
    filetypes = {"python"},
}

vim.lsp.enable('basedpyright')

-- Ty language server
-- vim.lsp.config['ty'] =  {
--     name = "ty",
--     cmd = {"ty", "server"},
--     root_markers = { {'pyproject.toml', 'setup.py'}, '.git' },
--     filetypes = {"python"},
-- }
-- vim.lsp.enable('ty')

-- Ruff
vim.lsp.config['ruff'] = {
    name = "ruff",
    cmd = {"ruff", "server"},
    root_markers = { {'pyproject.toml', 'setup.py'}, '.git' },
    filetypes = {"python"},
    init_options = {
        settings = {
            configurationPreference = "filesystemFirst"
        }
    }
}
vim.lsp.enable('ruff')
