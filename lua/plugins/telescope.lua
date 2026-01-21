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

        -- Get first line of hunk content (prefer removed for changes/deletes, added for adds)
        local first_line = ""
        local line_prefix = ""
        if hunk.removed and hunk.removed.lines and #hunk.removed.lines > 0 then
            first_line = hunk.removed.lines[1]
            line_prefix = "- "
        elseif hunk.added and hunk.added.lines and #hunk.added.lines > 0 then
            first_line = hunk.added.lines[1]
            line_prefix = "+ "
        end

        -- Remove leading whitespace
        first_line = first_line:gsub("^%s+", "")

        -- Truncate if too long
        local max_length = 60
        if #first_line > max_length then
            first_line = first_line:sub(1, max_length) .. "..."
        end

        local display_text = string.format("%s %s: %s | %s%s",
            type_icon, line_range, hunk.type, line_prefix, first_line)

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

    -- Create sorter without display highlighting
    local sorter = conf.generic_sorter(picker_opts)
    local original_highlighter = sorter.highlighter
    sorter.highlighter = function(_, prompt, display)
        -- Return empty highlights to disable visual highlighting on display text
        return {}
    end

    -- Function to update highlights in preview (defined after sorter/highlighter)
    local function update_preview_highlights(prompt_bufnr)
        local state = require('telescope.state')
        local status = state.get_status(prompt_bufnr)
        local picker = status.picker

        if not picker then
            return
        end

        -- Get preview buffer from previewer's internal state
        local previewer = picker.previewer
        if not previewer or not previewer.state then
            return
        end

        local preview_bufnr = previewer.state.bufnr
        if not preview_bufnr or not vim.api.nvim_buf_is_valid(preview_bufnr) then
            return
        end

        local action_state = require('telescope.actions.state')
        local entry = action_state.get_selected_entry(prompt_bufnr)
        if not entry or not entry.ordinal then
            return
        end

        local prompt = picker:_get_prompt()
        if prompt == "" then
            return
        end

        -- Get highlights from sorter
        local highlights = original_highlighter(sorter, prompt, entry.ordinal)
        if not highlights or #highlights == 0 then
            return
        end

        -- Get preview lines to build character map
        local preview_lines = vim.api.nvim_buf_get_lines(preview_bufnr, 0, -1, false)

        local ns_id = vim.api.nvim_create_namespace('telescope_hunk_matches')
        vim.api.nvim_buf_clear_namespace(preview_bufnr, ns_id, 0, -1)

        -- Build character position map (ordinal position -> preview buffer position)
        local char_to_pos = {}
        local char_pos = 1

        for i = 3, #preview_lines do
            local line = preview_lines[i]
            if line and #line > 0 then
                local content = line:sub(2)  -- Remove +/- prefix

                for j = 1, #content do
                    char_to_pos[char_pos] = { line = i - 1, col = j }
                    char_pos = char_pos + 1
                end

                char_pos = char_pos + 1  -- Account for newline in ordinal
            end
        end

        -- Apply highlights
        for _, pos in ipairs(highlights) do
            local mapped = char_to_pos[pos]
            if mapped then
                vim.api.nvim_buf_add_highlight(
                    preview_bufnr,
                    ns_id,
                    'TelescopeMatching',
                    mapped.line,
                    mapped.col,
                    mapped.col + 1
                )
            end
        end
    end

    local picker_obj = pickers.new(picker_opts, {
        prompt_title = 'Git Hunks',
        finder = finders.new_table({
            results = entries,
            entry_maker = function(entry) return entry end,
        }),
        sorter = sorter,
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

                -- Update highlights (also called via autocmd on prompt change)
                vim.schedule(function()
                    update_preview_highlights(status.picker.prompt_bufnr)
                end)
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

            -- Set up autocmd to update highlights on prompt change
            local augroup = vim.api.nvim_create_augroup('TelescopeHunkHighlight_' .. prompt_bufnr, { clear = true })
            vim.api.nvim_create_autocmd({'TextChangedI', 'TextChanged'}, {
                group = augroup,
                buffer = prompt_bufnr,
                callback = function()
                    update_preview_highlights(prompt_bufnr)
                end,
            })

            return true
        end,
    })

    picker_obj:find()
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
