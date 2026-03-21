local augroup = vim.api.nvim_create_augroup("nvim-config", { clear = true })

local function set_copilot_highlight()
  vim.api.nvim_set_hl(0, "CopilotSuggestion", {
    fg = "#89ddff",
    bg = "#1f2335",
    italic = false,
    bold = true,
    underline = true,
    undercurl = false,
    nocombine = true,
  })
end

set_copilot_highlight()

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  group = augroup,
  callback = set_copilot_highlight,
})

vim.api.nvim_create_autocmd({ "VimEnter", "InsertEnter" }, {
  group = augroup,
  callback = set_copilot_highlight,
})

vim.api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "LazyDone",
  callback = set_copilot_highlight,
})

vim.api.nvim_create_autocmd("VimResized", {
  group = augroup,
  command = "tabdo wincmd =",
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "php",
  callback = function()
    vim.opt_local.autoindent = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  group = augroup,
  pattern = "BlinkCmpMenuOpen",
  callback = function()
    local ok, suggestion = pcall(require, "copilot.suggestion")
    if ok then
      suggestion.dismiss()
    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  group = augroup,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    local buf = args.buf

    local map = function(lhs, rhs, desc, mode)
      vim.keymap.set(mode or "n", lhs, rhs, {
        buffer = buf,
        silent = true,
        desc = desc,
      })
    end

    map("K", vim.lsp.buf.hover, "Hover")
    map("gd", vim.lsp.buf.definition, "Goto definition")
    map("gD", vim.lsp.buf.declaration, "Goto declaration")
    map("gr", vim.lsp.buf.references, "References")
    map("gi", vim.lsp.buf.implementation, "Implementations")
    map("<leader>ca", vim.lsp.buf.code_action, "Code action", { "n", "x" })
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>lf", function()
      require("conform").format({
        async = false,
        lsp_format = "fallback",
      })
    end, "Format buffer")

    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
  end,
})

vim.keymap.set("i", "<C-f>", function()
  local ok, suggestion = pcall(require, "copilot.suggestion")
  if ok and suggestion.is_visible() then
    suggestion.accept()
  end
end, { silent = true, desc = "Accept Copilot suggestion" })

vim.keymap.set("i", "<C-g>", function()
  local ok, suggestion = pcall(require, "copilot.suggestion")
  if ok and suggestion.is_visible() then
    suggestion.next()
  end
end, { silent = true, desc = "Next Copilot suggestion" })
