-- Options.
vim.opt.number = true -- Show line numbers.
vim.opt.hidden = true -- Change buffers without saving.
vim.opt.visualbell = true -- No more annoying sunds.
vim.opt.termguicolors = true -- Add true color support.
vim.opt.splitbelow = true -- Open splits below insted at bottom.
vim.opt.splitright = true -- Open splits vertical right instead of left.
vim.opt.ignorecase = true -- Ignore case in a search.
vim.opt.smartcase = true -- Override the 'ignorecase' if the search pattern contains upper case.
vim.opt.hlsearch  = false -- Disable the highlightning of all the matches in a search.
vim.opt.shortmess:append('c') -- Suppress the annoying 'match x of y', 'The only match' and 'Pattern not found' messages.
vim.opt.shortmess:append('s') -- Suppres the messages of 'search hit BOTTOM'.
vim.opt.startofline = false -- Kept the cursor in the same column (if possible) when scrolling down.
vim.opt.cursorline = true -- Highlight the current line.
vim.opt.relativenumber = true
vim.opt.completeopt:remove("preview") -- Remove the window that appears below when autocompletion.
-- vim.opt.updatetime = 250 -- For gitgutter.
vim.opt.expandtab = true -- Space instead of tabs, when you press TAB.
vim.opt.tabstop = 4 -- The size of an actual TAB character.
vim.opt.shiftwidth = 4 -- The size in spaces of an indent. So the size when you press ">".
vim.opt.laststatus = 2 -- Always show the status bar, and tow different ones if split.
vim.opt.background = "dark" -- Type of colorscheme
