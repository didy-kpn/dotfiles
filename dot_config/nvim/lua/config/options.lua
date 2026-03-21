local g = vim.g
local opt = vim.opt

local undodir = vim.fn.stdpath("state") .. "/undo"
vim.fn.mkdir(undodir, "p")

g.mapleader = " "
g.maplocalleader = "\\"

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"
opt.termguicolors = true

opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.linebreak = true
opt.list = true
opt.listchars = {
  tab = ">-",
  trail = ".",
  nbsp = "_",
}

opt.clipboard = "unnamedplus"
opt.mouse = ""
opt.hidden = true
opt.splitbelow = true
opt.splitright = true
opt.splitkeep = "screen"
opt.inccommand = "split"
opt.confirm = true

opt.expandtab = true
opt.autoindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true
opt.breakindent = true
opt.backspace = { "start", "eol", "indent" }

opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = false
opt.incsearch = true

opt.pumheight = 12
opt.completeopt = { "menu", "menuone", "noselect" }
opt.updatetime = 200
opt.timeoutlen = 300

opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = undodir

opt.foldmethod = "expr"
opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
opt.foldlevel = 99
opt.foldlevelstart = 99

opt.fillchars = {
  eob = " ",
  fold = " ",
  foldopen = "-",
  foldclose = "+",
  foldsep = " ",
}

opt.shortmess:append("c")
opt.formatoptions:remove("o")
opt.formatoptions:append("rnj")
