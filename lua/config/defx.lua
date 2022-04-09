-- helper
local cmd, fn = vim.cmd, vim.fn
local nvim_set_keymap = vim.api.nvim_set_keymap
local buf_set_keymap = vim.api.nvim_buf_set_keymap

fn['defx#custom#option']('_', {
  direction = 'botright',
  resume = 1,
  split = 'vertical',
  -- split = 'floating',
  show_ignored_files = 1,
  -- toggle = 1,
  winwidth = 50,
})

nvim_set_keymap('n', '<Leader>e', '<CMD>Defx<CR>', {noremap = true, silent = true })

function _G.defx_settings()
  buf_set_keymap(0, 'n', 'q', 'defx#do_action("quit")', {noremap = true, silent = true, expr = true })
  buf_set_keymap(0, 'n', 'o', 'defx#is_directory() ? defx#do_action("open_tree") : defx#do_action("drop")', {noremap = true, silent = true, expr = true })
  buf_set_keymap(0, 'n', '<CR>', 'defx#do_action("drop")', {noremap = true, silent = true, expr = true })

  buf_set_keymap(0, 'n', 'K', 'defx#do_action("new_directory")', {noremap = true, silent = true, expr = true })
  buf_set_keymap(0, 'n', 'N', 'defx#do_action("new_file")', {noremap = true, silent = true, expr = true })

  buf_set_keymap(0, 'n', 'c', 'defx#do_action("copy")', {noremap = true, silent = true, expr = true })
  buf_set_keymap(0, 'n', 'm', 'defx#do_action("move")', {noremap = true, silent = true, expr = true })
  buf_set_keymap(0, 'n', 'p', 'defx#do_action("paste")', {noremap = true, silent = true, expr = true })

  buf_set_keymap(0, 'n', 'd', 'defx#do_action("remove")', {noremap = true, silent = true, expr = true})
  buf_set_keymap(0, 'n', 'r', 'defx#do_action("rename")', {noremap = true, silent = true, expr = true })

  buf_set_keymap(0, 'n', 'f', 'defx#do_action("drop", "pedit")', {noremap = true, silent = true, expr = true })
  buf_set_keymap(0, 'n', 'b', 'defx#do_action("cd", [".."])', {noremap = true, silent = true, expr = true })

  buf_set_keymap(0, 'n', 'v', 'defx#do_action("drop", "vsplit")', {noremap = true, silent = true, expr = true })
  buf_set_keymap(0, 'n', 's', 'defx#do_action("drop", "split")', {noremap = true, silent = true, expr = true })
  buf_set_keymap(0, 'n', 't', 'defx#do_action("drop", "tabnew")', {noremap = true, silent = true, expr = true })
end

cmd('autocmd FileType defx call v:lua.defx_settings()')
