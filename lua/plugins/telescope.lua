local function picker_with_opts(picker_function, opts)
    local function to_return()
        picker_function(opts)
    end
    return to_return
end

local function git_hunk_picker(opts)
    opts = opts or {}

    local pickers = require('telescope.pickers')
    local finders = require('telescope.finders')
    local previewers = require('telescope.previewers')
    local conf = require('telescope.config').values
    local actions = require('telescope.actions')
    local action_state = require('telescope.actions.state')

    -- Get current buffer and gitsigns cache
    local bufnr = vim.api.nvim_get_current_buf()
    local gs_cache = require('gitsigns.cache').cache[bufnr]

    if not gs_cache or not gs_cache.hunks or #gs_cache.hunks == 0 then
        vim.notify("No git hunks found in current buffer", vim.log.levels.WARN)
        return
    end

    local filename = vim.api.nvim_buf_get_name(bufnr)

    -- Build entries from hunks
    local entries = {}
    for idx, hunk in ipairs(gs_cache.hunks) do
        local ordinal_parts = {}

        -- Include removed lines in search
        if hunk.removed and hunk.removed.lines then
            vim.list_extend(ordinal_parts, hunk.removed.lines)
        end

        -- Include added lines in search
        if hunk.added and hunk.added.lines then
            vim.list_extend(ordinal_parts, hunk.added.lines)
        end

        -- Create display string
        local type_icon = ({
            add = "+",
            change = "~",
            delete = "-",
        })[hunk.type] or "?"

        local line_range = string.format("L%d-%d", hunk.added.start, hunk.vend)
        local display_text = string.format("%s %s: %s", type_icon, line_range, hunk.type)

        table.insert(entries, {
            value = hunk,
            ordinal = table.concat(ordinal_parts, '\n'),
            display = display_text,
            lnum = hunk.added.start,
            col = 1,
            filename = filename,
            bufnr = bufnr,
            hunk_index = idx,
        })
    end

    -- Override to enable preview for this picker
    local picker_opts = vim.tbl_deep_extend("force", {
        preview = true,
        layout_config = {
            horizontal = {
                preview_width = 0.5,
            },
        },
    }, opts)

    pickers.new(picker_opts, {
        prompt_title = 'Git Hunks',
        finder = finders.new_table({
            results = entries,
            entry_maker = function(entry) return entry end,
        }),
        sorter = conf.generic_sorter(picker_opts),
        previewer = previewers.new_buffer_previewer({
            title = "Hunk Preview",
            define_preview = function(self, entry, status)
                local hunk = entry.value
                local preview_lines = {}

                -- Add unified diff header
                table.insert(preview_lines, hunk.head)
                table.insert(preview_lines, "")

                -- Add removed lines with - prefix
                if hunk.removed and hunk.removed.lines then
                    for _, line in ipairs(hunk.removed.lines) do
                        table.insert(preview_lines, "-" .. line)
                    end
                end

                -- Add added lines with + prefix
                if hunk.added and hunk.added.lines then
                    for _, line in ipairs(hunk.added.lines) do
                        table.insert(preview_lines, "+" .. line)
                    end
                end

                -- Set lines in preview buffer
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines)

                -- Apply diff syntax highlighting
                vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', 'diff')
            end,
        }),
        attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
                local entry = action_state.get_selected_entry()
                actions.close(prompt_bufnr)

                -- Jump to hunk location
                vim.api.nvim_set_current_buf(entry.bufnr)
                vim.api.nvim_win_set_cursor(0, {entry.lnum, 0})

                -- Center the view
                vim.cmd('normal! zz')
            end)
            return true
        end,
    }):find()
end

return {
    "nvim-telescope/telescope.nvim",
    version = '*',
    enabled = true,
    dependencies = {
        'nvim-lua/plenary.nvim',
        -- optional but recommended
        -- { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function ()
        local builtin = require("telescope.builtin")
        local actions = require("telescope.actions")

        telescope = require("telescope")

        telescope.setup({
            defaults = {
                preview = false,
                color_devicons = false,
                sorting_strategy = "ascending",
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
                        ["<Tab>"] = actions.move_selection_next,
                        ["<S-Tab>"] = actions.move_selection_previous,
                    },
                },
                layout_config = {
                    horizontal = {
                        height = 0.4,
                        preview_cutoff = 120,
                        prompt_position = "top",
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
        vim.keymap.set('n', '<leader>ff', builtin.buffers, opts)
        vim.keymap.set('n', '<leader>ll', builtin.find_files, opts)
        
        vim.keymap.set('n', '<leader>fs', picker_with_opts(builtin.lsp_dynamic_workspace_symbols, {ignore_symbols = "variable"}), opts)
        vim.keymap.set('n', '<leader>fd', picker_with_opts(builtin.lsp_document_symbols, {show_line = true}), opts)

        -- Git hunk picker
        vim.keymap.set('n', '<leader>fg', git_hunk_picker, opts)
    end
}
