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

keymap.set("n", "<leader>tn", function()
  require("neotest").run.run()
end, { desc = "Test nearest" })
keymap.set("n", "<leader>tf", function()
  require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Test file" })

local function php_test_root()
  local file = vim.api.nvim_buf_get_name(0)
  return vim.fs.root(file, { "composer.json", "phpunit.xml", "phpunit.xml.dist", "artisan" }) or vim.fn.getcwd()
end

local function nearest_phpunit_method()
  local current_line = vim.api.nvim_win_get_cursor(0)[1]
  local lines = vim.api.nvim_buf_get_lines(0, 0, current_line, false)

  for i = #lines, 1, -1 do
    local name = lines[i]:match("function%s+([%w_]+)%s*%(")
    if name then
      return name
    end
  end
end

local function php_dap_config(args)
  local root = php_test_root()
  return {
    type = "php",
    request = "launch",
    name = "Debug PHPUnit",
    port = 9003,
    cwd = root,
    program = vim.fn.expand("~/.local/bin/phpunit-neotest"),
    args = args,
  }
end

keymap.set("n", "<leader>td", function()
  local file = vim.fn.expand("%:p")
  local args = { file }
  local method = nearest_phpunit_method()

  if method then
    vim.list_extend(args, { "--filter", "::" .. method .. "( with data set .*)?$" })
  end

  require("dap").run(php_dap_config(args))
end, { desc = "Test debug nearest" })
keymap.set("n", "<leader>tD", function()
  require("dap").run(php_dap_config({ vim.fn.expand("%:p") }))
end, { desc = "Test debug file" })
keymap.set("n", "<leader>tt", function()
  require("neotest").run.run_last()
end, { desc = "Test last" })
keymap.set("n", "<leader>to", function()
  require("neotest").output.open({ enter = true, auto_close = true })
end, { desc = "Test output" })
keymap.set("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Test summary" })

keymap.set("n", "<leader>dc", function()
  require("dap").continue()
end, { desc = "Debug continue" })
keymap.set("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Debug breakpoint" })
keymap.set("n", "<leader>di", function()
  require("dap").step_into()
end, { desc = "Debug step into" })
keymap.set("n", "<leader>do", function()
  require("dap").step_over()
end, { desc = "Debug step over" })
keymap.set("n", "<leader>dO", function()
  require("dap").step_out()
end, { desc = "Debug step out" })
keymap.set("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Debug UI" })
keymap.set("n", "<leader>dr", function()
  require("dap").repl.toggle()
end, { desc = "Debug REPL" })
keymap.set("n", "<leader>dx", function()
  require("dap").terminate()
end, { desc = "Debug terminate" })
