local status, tundra = pcall(require, "nvim-tundra")

if not status then
    return
end

-- This is a hack it must be reported to the main repo.
vim.opt.background = 'dark'

tundra.setup({})
vim.cmd('colorscheme tundra')
