return {
    "ggandor/leap.nvim",
    lazy = false,
    config = function ()
        local leap = require("leap")

        -- Don't jump to the first match
        -- leap.opts.safe_labels = {}

        vim.keymap.set('n', 's', "<Plug>(leap-forward-to)", { noremap = true, silent = true})
        vim.keymap.set('n', 'S', "<Plug>(leap-backward-to)", { noremap = true, silent = true})
    end
}
