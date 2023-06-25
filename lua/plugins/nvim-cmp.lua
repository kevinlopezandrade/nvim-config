return {
    'hrsh7th/nvim-cmp',
    lazy = false,
    dependencies = {
        'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-buffer',
        'hrsh7th/cmp-path',
        'dcampos/nvim-snippy',
        'dcampos/cmp-snippy'
    },
    config = function ()
        local cmp = require("cmp")
        local prev_item = function(fallback)
            if cmp.visible() then
                -- By default does INSERT.
                cmp.select_prev_item()
            else
                fallback()
            end
        end

        local next_item = function(fallback)
            if cmp.visible() then
                -- By default does INSERT.
                cmp.select_next_item()
            else
                fallback()
            end
        end

        local not_in_prompt = function()
            local buftype = vim.api.nvim_buf_get_option(0, "buftype")
            if buftype == "prompt" then 
                return false
            end
            return true
        end

        cmp.setup({
            enabled = not_in_prompt,
            preselect = cmp.PreselectMode.None,
            sources = {
                { name = 'nvim_lsp', group_index = 1},
                { name = "snippy", group_index = 1},
                {
                    name = 'buffer',
                    option = {
                        get_bufnrs = function()
                            return vim.api.nvim_list_bufs()
                        end
                    },
                    group_index = 2
                },
                { name = "path", group_index = 2},
            },
            mapping = { 
                ['<CR>'] = {
                    i = cmp.mapping.confirm({ select = false })
                },
                ["<Tab>"] = {
                    i = next_item
                },
                ["<S-Tab>"] = {
                    i = prev_item
                }
            },
            snippet = {
                expand = function(args)
                    require('snippy').expand_snippet(args.body)
                end
            }
        })
    end
}
