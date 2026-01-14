return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    branch = "master",
    config = function ()
        local configs = require("nvim-treesitter.configs")
        configs.setup({
            highlight = { enable = true },
            textobjects = { enable = true },
            indent = { enable = true}
        })
    end
}
