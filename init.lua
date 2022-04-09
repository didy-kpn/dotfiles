-- helper
local cmd, g = vim.cmd, vim.g

-- vim init
cmd([[
if !1 | finish | endif

augroup _vimrc
  autocmd!
augroup END
]])

-- set leader key
g.mapleader = ' '

-- import options
require('plugins')
require('settings')
require('autocommands')
require('keymappings')
