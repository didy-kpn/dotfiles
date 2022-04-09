-- helper
local fn = vim.fn
local nvim_set_keymap = vim.api.nvim_set_keymap

-- key mapping
nvim_set_keymap('n', '<Space>', '<Nop>', {noremap = true})
nvim_set_keymap('v', '<Space>', '<Nop>', {noremap = true})

nvim_set_keymap('n', '<C-l>', 'gt', {noremap = true})
nvim_set_keymap('n', '<C-h>', 'gT', {noremap = true})

nvim_set_keymap('n', '<Leader>vs', '<CMD>vs<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>sp', '<CMD>sp<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>vsn', '<CMD>vs enew<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>spn', '<CMD>sp enew<CR>', {noremap = true, silent = true})

nvim_set_keymap('n', '<Esc><Esc>', '<CMD>nohlsearch<CR>', {noremap = true, silent = true})

nvim_set_keymap('n', '<Leader>ay', '<CMD>%yank<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>ad', '<CMD>%delete<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>y', 'yiw', {noremap = true})
nvim_set_keymap('n', '<Leader>d', 'diw', {noremap = true})

nvim_set_keymap('i', '{{', '{}<LEFT>', {noremap = true})
nvim_set_keymap('i', '[[', '[]<LEFT>', {noremap = true})
nvim_set_keymap('i', '((', '()<LEFT>', {noremap = true})
nvim_set_keymap('i', '""', '""<LEFT>', {noremap = true})
nvim_set_keymap('i', '\'\'', '\'\'<LEFT>', {noremap = true})
nvim_set_keymap('i', '<<', '<><LEFT>', {noremap = true})

nvim_set_keymap('i', '}}', '{}<LEFT>', {noremap = true})
nvim_set_keymap('i', ']]', '[]<LEFT>', {noremap = true})
nvim_set_keymap('i', '))', '()<LEFT>', {noremap = true})
nvim_set_keymap('i', '>>', '<><LEFT>', {noremap = true})

nvim_set_keymap('n', '<Leader>bn', '<CMD>bnext<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>bp', '<CMD>bprevious<CR>', {noremap = true, silent = true})

nvim_set_keymap('n', '<Leader>g', '<CMD>vim<Space>"<C-r><C-w>"<Space><C-r>=getcwd()<CR>/**', {noremap = true})

nvim_set_keymap('t', '<Esc>', '<C-\\><C-n>', {noremap = true, silent = true})
