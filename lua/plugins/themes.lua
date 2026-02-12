return {
    {
        "ellisonleao/gruvbox.nvim",
        enabled = false,
    },
    {
    "rebelot/kanagawa.nvim",
        enabled= false
    },
    {
        "EdenEast/nightfox.nvim",
        priority = 1000,
        lazy = false,
        enabled = True,
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
    },

    {
        "neovim-idea/catppuccin-reloaded-nvim",
        dependencies = { "catppuccin/nvim" },
        enabled = false,
        priority = 500,
        config = function()
            require("catppuccin-reloaded").setup({
                -- here you can insert your usual catppuccin options
                catppuccin = {}
            })
        end,
    }

}
