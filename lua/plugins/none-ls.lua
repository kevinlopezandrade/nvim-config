return {
    'nvimtools/none-ls.nvim',
    lazy = false,
    enabled = true,
    config = function ()
        local null_ls = require("null-ls")
        null_ls.setup({
            sources = {
                null_ls.builtins.formatting.isort,
                null_ls.builtins.formatting.black,
            },
        })
    end
}
