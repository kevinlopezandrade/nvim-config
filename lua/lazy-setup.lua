-- Bootstrap Lazy if path not found.
-- By default is $HOME/.local/share/nvim/lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

-- Add the lazypath to the list of directories
-- to be searched when looking for runtime files
vim.opt.rtp:prepend(lazypath)


local opts = {
    change_detection = {
        enabled = false,
        notify = false
    }
}

-- Start Lazy
-- This will parse and execute every lua file inside the 'confs/'
-- and it expects a plugin-spec from every lua file inside there.
require("lazy").setup("plugins", opts)
