-- helper
local cmd, fn = vim.cmd, vim.fn

-- Display and highlight ZenkakuSpace
function ZenkakuSpace()
  cmd('highlight ZenkakuSpace cterm=reverse ctermfg=DarkMagenta gui=reverse guifg=DarkMagenta')
end

if fn.has('syntax') == 1 then
  cmd('autocmd _vimrc ColorScheme       * call ZenkakuSpace()')
  cmd('autocmd _vimrc VimEnter,WinEnter * match ZenkakuSpace /　/')
  ZenkakuSpace()
end

-- Yank highlight
cmd('au TextYankPost * silent! lua vim.highlight.on_yank()')

-- FIXME:
-- function MakeSession()
--   local sessiondir = os.getenv("XDG_CONFIG_HOME")..'/nvim/sessions/' .. fn.getcwd('%:p')
--   if fn.filereadable(sessiondir) == 0 then
--     cmd('silent !mkdir -p ' .. sessiondir)
--   end
--   local sessionfile = sessiondir .. '/session.vim'
--   cmd('mksession! ' .. sessionfile)
-- end

-- function LoadSession()
--   local sessiondir = os.getenv("XDG_CONFIG_HOME")..'/nvim/sessions/' .. fn.getcwd('%:p')
--   local sessionfile = sessiondir .. '/session.vim'
--   if fn.filereadable(sessionfile) == 1 then
--     cmd('source ' .. sessionfile)
--   else
--     print('No session loaded.')
--   end
-- end

-- -- make and load sessionfile
-- cmd('augroup vimSessions')
-- cmd('autocmd!')
-- cmd('au VimEnter * nested :lua  LoadSession()')
-- cmd('au VimLeave * :lua MakeSession()')
-- cmd('augroup END')
