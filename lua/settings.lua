-- helper
local cmd, fn, g, opt = vim.cmd, vim.fn, vim.g, vim.opt

-- options
g.python3_host_prog = fn.system('echo -n $(which python3)')

cmd('filetype plugin indent on')
cmd('colorscheme hybrid')
cmd('syntax on')

opt.backup = true
opt.backupdir = os.getenv("XDG_CONFIG_HOME")..'/nvim/backup'

opt.swapfile = true
opt.directory = os.getenv("XDG_CONFIG_HOME")..'/nvim/swap'

opt.undofile = true
opt.undodir = os.getenv("XDG_CONFIG_HOME")..'/nvim/undo'

opt.hidden = true
opt.clipboard = 'unnamedplus'
opt.wrap = false
opt.number = true
opt.ignorecase = true
opt.expandtab = true
opt.tabstop = 2
opt.laststatus = 2
opt.ambiwidth = 'double'
opt.cursorline = true
opt.list = true
opt.listchars ='tab:>.,trail:_,extends:>,precedes:<,nbsp:%'
opt.shiftwidth = 2
opt.softtabstop = 2
opt.inccommand = 'split'
opt.number = true
opt.signcolumn = 'yes'
opt.termguicolors = true
