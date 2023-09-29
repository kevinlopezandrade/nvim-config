return {
    {
        "ellisonleao/gruvbox.nvim",
    },
    "rebelot/kanagawa.nvim",
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        lazy = false,
        config = function()
            vim.cmd("colorscheme duskfox")
        end
    },
    {
        'sam4llis/nvim-tundra',
        lazy = false,
        config = function()
            -- local tundra = require("nvim-tundra")
            -- tundra.setup({})
            -- vim.cmd("colorscheme tundra")
        end
    }
}
