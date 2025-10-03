return {
    "ggandor/leap.nvim",
    lazy = false,
    config = function ()
        local leap = require("leap")

        -- Don't jump to the first match
        -- leap.opts.safe_labels = {}

        vim.keymap.set('n', 's', "<Plug>(leap)", { noremap = true, silent = true})
    end
}
