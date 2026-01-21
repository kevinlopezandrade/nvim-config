return {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    enabled = false,
    ---@type snacks.Config
    opts = {
        picker = {
            enabled = true,
            -- Disable file icons
            icons = {
                files = {
                    enabled = false,
                },
            },
            -- Hide preview by default
            layout = {
                hidden = { "preview" },
            },
            -- Tab to move without multi-selection
            win = {
                input = {
                    keys = {
                        ["<Tab>"] = { "list_down", mode = { "i", "n" } },
                        ["<S-Tab>"] = { "list_up", mode = { "i", "n" } },
                    },
                },
                list = {
                    keys = {
                        ["<Tab>"] = "list_down",
                        ["<S-Tab>"] = "list_up",
                    },
                },
            },
            -- Configure sources with file exclusions
            sources = {
                files = {
                    exclude = {
                        "*.pkl",
                        "*.jpg",
                        "*.jpeg",
                        "*.png",
                        "*.pyc",
                        "*/__marimo__/*",
                    },
                },
                lsp_workspace_symbols = {
                    -- Filter out variables (similar to telescope ignore_symbols = "variable")
                    filter = {
                        Variable = false,
                    },
                },
            },
        },
    },
    keys = {
        -- Migrated from telescope keymaps
        { '<leader>ff', function() require('snacks').picker.buffers() end, desc = 'Buffers', noremap = true, silent = true },
        { '<leader>ll', function() require('snacks').picker.files() end, desc = 'Find Files', noremap = true, silent = true },
        { '<leader>fs', function() require('snacks').picker.lsp_workspace_symbols() end, desc = 'LSP Workspace Symbols', noremap = true, silent = true },
        { '<leader>fd', function() require('snacks').picker.lsp_symbols() end, desc = 'LSP Document Symbols', noremap = true, silent = true },
        { '<leader>fg', function() require('snacks').picker.git_diff() end, desc = 'Git Hunks', noremap = true, silent = true },
    },
}
