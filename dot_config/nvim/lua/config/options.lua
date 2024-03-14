-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- helper
local g, opt = vim.g, vim.opt

g.mapleader = " "

vim.scriptencoding = "utf-8"
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

opt.number = true

opt.title = true
opt.autoindent = true
opt.smartindent = true
opt.hlsearch = true

-- TODO:
opt.backup = false
-- opt.backupdir = os.getenv("XDG_CONFIG_HOME") .. "/nvim/backup"

opt.swapfile = false
-- opt.directory = os.getenv("XDG_CONFIG_HOME") .. "/nvim/swap"

opt.undofile = false
-- opt.undodir = os.getenv("XDG_CONFIG_HOME") .. "/nvim/undo"

opt.hidden = true
opt.clipboard = "unnamedplus"
opt.showcmd = true
opt.cmdheight = 0
opt.laststatus = 2
opt.expandtab = true
opt.scrolloff = 10
opt.inccommand = "split"
opt.ignorecase = true
opt.smarttab = true
opt.breakindent = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.wrap = false
opt.backspace = { "start", "eol", "indent" }
opt.splitbelow = true
opt.splitkeep = "cursor"
opt.mouse = ""
opt.cursorline = true
opt.ambiwidth = "single"
opt.signcolumn = "yes"
opt.termguicolors = true
opt.list = true
-- TODO:
-- opt.listchars = { tab = ">.", trail = "_", extends = ">", precedes = "<", nbsp = "%" }

opt.formatoptions:append({ "r" })
