-- helper
local api, bo, cmd, fn, g, o = vim.api, vim.bo, vim.cmd, vim.fn, vim.g, vim.o
local nvim_set_keymap = vim.api.nvim_set_keymap

g.coc_global_extensions = { 'coc-json', 'coc-yaml', 'coc-pyright', 'coc-rust-analyzer', 'coc-deno' }

function _G.check_back_space()
  local col = fn.col(".") - 1
  if col == 0 or fn.getline("."):sub(col, col):match("%s") then
    return true
  else
    return false
  end
end

-- Completion
nvim_set_keymap("i", "<TAB>", 'pumvisible() ? "<C-N>" : v:lua.check_back_space() ? "<TAB>" : coc#refresh()', {noremap = true, silent = true, expr = true})
nvim_set_keymap('i', '<S-TAB>', 'pumvisible() ? "<C-p>" : "<C-h>"', {noremap = true, silent = true, expr = true})

nvim_set_keymap('i', '<C-l>', 'coc#refresh()', {noremap = true, silent = true, expr = true})
nvim_set_keymap("i", "<CR>", 'pumvisible() ? coc#_select_confirm() : "<C-g>u<CR><C-r>=coc#on_enter()<CR>"', {noremap = true, silent = true, expr = true})

-- navigate diagnostic
nvim_set_keymap('n', '[g', '<Plug>(coc-diagnostic-prev)', {noremap = false, silent = true})
nvim_set_keymap('n', ']g', '<Plug>(coc-diagnostic-next)', {noremap = false, silent = true})

-- goto definition
nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {noremap = false, silent = true})
nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', {noremap = false, silent = true})
nvim_set_keymap('n', 'gi', '<Plug>(coc-implementation)', {noremap = false, silent = true})
nvim_set_keymap('n', 'gr', '<Plug>(coc-references)', {noremap = false, silent = true})

function _G.show_documentation()
  if fn.index({ 'vim', 'help' }, bo.filetype) >= 0 then
    cmd('h ' .. fn.expand('<cword>'))
  elseif api.nvim_eval('coc#rpc#ready()') then
    fn.CocActionAsync('doHover')
  else
    cmd('! ' .. o.keywordprg .. ' ' .. fn.expand('<cword>'))
  end
end

-- show reference
nvim_set_keymap('n', '<Leader>lk', '<CMD>lua _G.show_documentation()<CR>', {noremap = false, silent = true})

-- scroll float popups
nvim_set_keymap('n', '<C-f>', 'coc#float#has_scroll() ? coc#float#scroll(1) : "<C-f>"', {noremap = true, silent = true, expr = true})
nvim_set_keymap('n', '<C-b>', 'coc#float#has_scroll() ? coc#float#scroll(0) : "<C-b>"', {noremap = true, silent = true, expr = true})
nvim_set_keymap('i', '<C-f>', 'coc#float#has_scroll() ? "<C-r>=coc#float#scroll(1)<CR>" : "<Right>"', {noremap = true, silent = true, expr = true})
nvim_set_keymap('i', '<C-b>', 'coc#float#has_scroll() ? "<C-r>=coc#float#scroll(0)<CR>" : "<Left>"', {noremap = true, silent = true, expr = true})

nvim_set_keymap('n', '<C-k>', '<Plug>(coc-float-jump)', {noremap = false, silent = true})
nvim_set_keymap('i', '<C-k>', '<Plug>(coc-float-jump)', {noremap = false, silent = true})

-- format
nvim_set_keymap('n', '<Leader>lr', '<Plug>(coc-rename)', {noremap = false, silent = true})
nvim_set_keymap('n', '<Leader>lf', '<CMD>call CocAction("format")<CR><CMD>call CocAction("runCommand", "editor.action.organizeImport")<CR>', {noremap = true, silent = true})

-- mappings for coclist
nvim_set_keymap('n', '<Leader>la', '<CMD><C-u>CocList diagnostics<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>le', '<CMD><C-u>CocList extensions<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>lc', '<CMD><C-u>CocList commands<CR>', {noremap = true, silent = true})
nvim_set_keymap('n', '<Leader>lo', '<CMD><C-u>CocList outline<CR>', {noremap = true, silent = true})
