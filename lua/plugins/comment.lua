local opts = {
    mappings = {
        extra = false
    }
}
return {
    'numToStr/Comment.nvim',
    lazy = false,
    config = function ()
        require("Comment").setup(opts)
    end
}
