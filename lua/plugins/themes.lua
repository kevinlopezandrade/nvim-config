return {
    {
        "ellisonleao/gruvbox.nvim",
    },
    "rebelot/kanagawa.nvim",
    {
        'sam4llis/nvim-tundra',
        priority = 1000,
        lazy = false,
        config = function()
            local tundra = require("nvim-tundra")
            tundra.setup({})
            vim.cmd("colorscheme tundra")
        end
    }
}
