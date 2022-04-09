-- helper
local g = vim.g
local nvim_set_keymap = vim.api.nvim_set_keymap

nvim_set_keymap('n', '<Leader>ff', '<CMD>lua require("telescope.builtin").find_files()<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>fk', '<CMD>lua require("telescope.builtin").keymaps()<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>fb', '<CMD>lua require("telescope.builtin").buffers()<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>fc', '<CMD>lua require("telescope.builtin").command_history()<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>fg', '<CMD>lua require("telescope.builtin").live_grep()<CR>', {noremap = true, silent = true})
