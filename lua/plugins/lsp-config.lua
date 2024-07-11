return {
    'neovim/nvim-lspconfig',
    lazy = false,
    config = function ()
        require("lspconfig").texlab.setup{
            settings = {
                texlab = {
                    build = {
                        executable = 'tectonic',
                        args = {"--synctex", "--keep-logs", "--keep-intermediates", "%f"}
                    }
                }
            }
        }
    end
}
