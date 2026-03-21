local keymap = vim.keymap
local opts = { noremap = true, silent = true }

keymap.set("n", "x", '"_x')
keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", opts)

-- Select all
keymap.set("n", "<Leader>ay", "gg<S-v>G")

keymap.set("n", "<leader>w", "<cmd>write<cr>", { desc = "Save", silent = true })
keymap.set("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit", silent = true })

keymap.set("n", "<leader>-", "<cmd>split<cr>", { desc = "Horizontal split", silent = true })
keymap.set("n", "<leader>|", "<cmd>vsplit<cr>", { desc = "Vertical split", silent = true })

keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to left window", silent = true })
keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to lower window", silent = true })
keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to upper window", silent = true })
keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to right window", silent = true })

keymap.set("n", "<leader>h", "<cmd>bprevious<cr>", { desc = "Previous buffer", silent = true })
keymap.set("n", "<leader>l", "<cmd>bnext<cr>", { desc = "Next buffer", silent = true })
keymap.set("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer", silent = true })

keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory", silent = true })

keymap.set("n", "<leader>ff", function()
  require("snacks").picker.files()
end, { desc = "Find files" })
keymap.set("n", "<leader>fg", function()
  require("snacks").picker.grep()
end, { desc = "Live grep" })
keymap.set("n", "<leader>fb", function()
  require("snacks").picker.buffers()
end, { desc = "Buffers" })
keymap.set("n", "<leader>fr", function()
  require("snacks").picker.recent()
end, { desc = "Recent files" })
keymap.set("n", "<leader>fh", function()
  require("snacks").picker.help()
end, { desc = "Help tags" })
keymap.set("n", "<leader>fd", function()
  require("snacks").picker.diagnostics()
end, { desc = "Diagnostics list" })
keymap.set("n", "<leader>sr", function()
  require("grug-far").open({
    prefills = {
      search = vim.fn.expand("<cword>"),
    },
  })
end, { desc = "Search and replace" })

keymap.set("n", "s", function()
  require("flash").jump()
end, { desc = "Flash jump" })
keymap.set("n", "S", function()
  require("flash").treesitter()
end, { desc = "Flash treesitter" })
keymap.set({ "o", "x" }, "r", function()
  require("flash").remote()
end, { desc = "Remote flash" })
keymap.set({ "o", "x" }, "R", function()
  require("flash").treesitter_search()
end, { desc = "Treesitter search" })

keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Line diagnostics" })
keymap.set("n", "<leader>xq", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })
keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP info", silent = true })

keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>", { desc = "LazyGit", silent = true })
keymap.set("n", "<leader>gb", function()
  require("gitsigns").blame_line({ full = true })
end, { desc = "Git blame line" })
keymap.set("n", "<leader>gd", function()
  require("gitsigns").diffthis()
end, { desc = "Git diff this" })
keymap.set("n", "<leader>gh", function()
  require("gitsigns").preview_hunk()
end, { desc = "Preview hunk" })

keymap.set({ "n", "x" }, "<leader>ma", "<cmd>MultipleCursorsAddMatches<cr>", { desc = "Add cursors to matches", silent = true })
keymap.set({ "n", "x" }, "<leader>mn", "<cmd>MultipleCursorsAddJumpNextMatch<cr>", { desc = "Add cursor and next match", silent = true })
keymap.set({ "n", "x" }, "<leader>mN", "<cmd>MultipleCursorsAddJumpPrevMatch<cr>", { desc = "Add cursor and previous match", silent = true })
keymap.set("x", "<leader>mv", "<cmd>MultipleCursorsAddVisualArea<cr>", { desc = "Add cursors to visual lines", silent = true })
keymap.set({ "n", "x" }, "<leader>ml", "<cmd>MultipleCursorsLockToggle<cr>", { desc = "Toggle cursor lock", silent = true })
