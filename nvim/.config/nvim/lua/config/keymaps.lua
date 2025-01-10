-- This file is automatically loaded by lazyvim.config.init
local map = vim.keymap.set

-- Netrw
map('n', '<leader>e', '<CMD>Lexplore<CR>', { desc = 'Netrw' })
map('n', '-', '<CMD>Explore<CR>', { desc = 'Open parent directory' })

-- Move to window using the <ctrl> hjkl keys
map('n', '<C-h>', '<C-w>h', { desc = 'Go to Left Window', remap = true })
map('n', '<C-l>', '<C-w>l', { desc = 'Go to Right Window', remap = true })
map('n', '<C-j>', '<C-w>j', { desc = 'Go to Lower Window', remap = true })
map('n', '<C-k>', '<C-w>k', { desc = 'Go to Upper Window', remap = true })

-- Resize window using <ctrl> arrow keys
map('n', '<M-Up>', '<CMD>resize +2<CR>', { desc = 'Increase Window Height' })
map('n', '<M-Down>', '<CMD>resize -2<CR>', { desc = 'Decrease Window Height' })
map('n', '<M-Left>', '<CMD>vertical resize -2<CR>', { desc = 'Decrease Window Width' })
map('n', '<M-Right>', '<CMD>vertical resize +2<CR>', { desc = 'Increase Window Width' })

-- Move lines
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

-- Run tmux-sessionizer
map('n', '<C-f>', '<CMD>silent !tmux neww tmux-sessionizer<CR>')

-- Clear search and stop snippet on escape
map({ 'n', 's' }, '<C-c>', '<CMD>nohlsearch<CR>', { desc = 'Escape and Clear hlsearch' })

-- Add undo break-points
map('i', ',', ',<c-g>u')
map('i', '.', '.<c-g>u')
map('i', ';', ';<c-g>u')

--keywordprg
map('n', '<leader>K', '<CMD>norm! K<CR>', { desc = '[K]eywordprg' })

-- better indenting
map('v', '<', '<gv')
map('v', '>', '>gv')

-- diagnostic
map('n', '<leader>cd', vim.diagnostic.open_float, { desc = 'Line Diagnostics' })
