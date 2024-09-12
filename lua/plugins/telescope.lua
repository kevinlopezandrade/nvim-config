local function picker_with_opts(picker_function, opts)
    local function to_return()
        picker_function(opts)
    end
    return to_return
end

return {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.8",
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function ()
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")

        telescope = require("telescope")

        telescope.setup({
            defaults = {
                preview = false,
                color_devicons = false,
                file_ignore_patterns = {
                    "%.pkl",
                    "%.jpg",
                    "%.jpeg",
                    "%.png",
                    "%.pyc"
                },
                mappings = {
                    i = {
                        ["<esc>"] = actions.close,
                        ["<C-k>"] = actions.move_selection_previous,
                        ["<C-j>"] = actions.move_selection_next,
                    },
                },
                layout_config = {
                    horizontal = {
                        height = 0.4,
                        preview_cutoff = 120,
                        prompt_position = "bottom",
                        width = 0.55
                    },
                }
            },
            pickers = {
                find_files = {
                    disable_devicons = true
                },
                buffers = {
                    disable_devicons = true
                }
            },
        })

        local opts = { noremap = true, silent = true }
        -- vim.keymap.set('n', '<leader>ff', builtin.find_files, opts)
        vim.keymap.set('n', '<leader>ff', builtin.buffers, opts)

        vim.keymap.set('n', '<leader>fm', builtin.marks, opts)

        vim.keymap.set('n', '<leader>fs', picker_with_opts(builtin.lsp_dynamic_workspace_symbols, {ignore_symbols = "variable"}), opts)
        vim.keymap.set('n', '<leader>fd', picker_with_opts(builtin.lsp_document_symbols, {show_line = true}), opts)
    end
}
