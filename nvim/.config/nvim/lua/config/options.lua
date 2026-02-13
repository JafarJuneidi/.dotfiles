vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- wl-clipboard issue when banner is off
vim.g.netrw_banner = 1

vim.opt.guicursor = 'a:block'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.mouse = 'a'
vim.opt.showmode = false

vim.schedule(function()
    -- Don't forget to install xclip!
    vim.opt.clipboard = 'unnamedplus'
end)
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv 'HOME' .. '/.vim/undodir'
vim.opt.undofile = true

-- vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.cursorline = true
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.inccommand = 'split'
vim.opt.wrap = false
vim.opt.conceallevel = 0
-- required for bufferline
vim.opt.termguicolors = true
