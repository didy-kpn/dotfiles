-- helper
local cmd,fn = vim.cmd,vim.fn

-- Plugin
cmd 'packadd paq-nvim'
local paq = require'paq-nvim'.paq
paq {'savq/paq-nvim', opt=true}

paq 'rhysd/clever-f.vim'
paq 'tpope/vim-surround'
paq 'tpope/vim-commentary'
paq 'i-amd3/BlockDiff'

paq {'neoclide/coc.nvim', branch='release'}
paq {'nvim-treesitter/nvim-treesitter', run = function() vim.cmd 'TSUpdate' end }

paq 'w0ng/vim-hybrid'
paq 'PHSix/nvim-hybrid'

paq 'nvim-lua/popup.nvim'
paq 'nvim-lua/plenary.nvim'
paq 'nvim-telescope/telescope.nvim'

paq 'airblade/vim-gitgutter'
paq 'itchyny/lightline.vim'

paq 'tpope/vim-dadbod'
paq 'kristijanhusak/vim-dadbod-ui'

paq 'Shougo/defx.nvim'

paq 'ellisonleao/glow.nvim'

paq 'github/copilot.vim'

-- Plugin Config
require 'config.coc'
require 'config.nvim-treesitter'
require 'config.defx'
require 'config.telescope'
