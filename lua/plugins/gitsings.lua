return {
    'lewis6991/gitsigns.nvim',
    lazy = false,
    config = function ()
        gs = require("gitsigns")

        local function move_next()
            if vim.wo.diff then
                return ']c'
            end
            vim.schedule(function() gs.next_hunk() end)
            return '<Ignore>'
        end

        local function move_prev()
            if vim.wo.diff then
                return '[c'
            end
            vim.schedule(function() gs.prev_hunk() end)
            return '<Ignore>'
        end

        local on_attach = function()
            vim.keymap.set('n', ']c', move_next, {expr=true})
            vim.keymap.set('n', '[c', move_prev, {expr=true})
            vim.keymap.set('n', '<leader>hp', gs.preview_hunk, {noremap=true, silent=true})
        end

        gs.setup({
            on_attach = on_attach
        })
    end
}
