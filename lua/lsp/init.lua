-- LSP Config

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "x",
            [vim.diagnostic.severity.WARN] = "w",
            [vim.diagnostic.severity.HINT] = "h",
            [vim.diagnostic.severity.INFO] = "#",
        },
    },
    virtual_text = false,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = "always",
    },
})

-- LSP Server configurations.
local conform = require("conform")
conform.setup({
    -- log_level = vim.log.levels.DEBUG,
    formatters = {
        ruff_organize_imports = {
            -- We replace "I001" with "I" to include "required-imports" (I002)
            args = {
                "check",
                "--force-exclude",
                "--select=I",
                "--fix",
                "--exit-zero",
                "--no-cache",
                "--stdin-filename",
                "$FILENAME",
                "-"
            },
        },
    },
    formatters_by_ft = {
        python = {
            -- To organize the imports.
            "ruff_organize_imports",

            -- To run the Ruff formatter.
            "ruff_format",
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
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', '<leader>lf', function()
            conform.format({ lsp_fallback = true })
        end, opts)
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
--
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.general.positionEncodings = { "utf-16" }

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
    },
    capabilities = capabilities,
    on_attach = function(client, bufnr)
        -- Disable the LSP formatter so it doesn't fight with Conform
        client.server_capabilities.documentFormattingProvider = false

        -- (Optional) Disable Hover if you prefer Pyright/BasedPyright for type info,
        -- though Ruff's hover is useful for explaining linting rules.
        client.server_capabilities.hoverProvider = false
    end
}
vim.lsp.enable('ruff')
