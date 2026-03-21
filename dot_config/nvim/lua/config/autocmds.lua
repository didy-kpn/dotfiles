local augroup = vim.api.nvim_create_augroup("nvim-config", { clear = true })

vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank({ higroup = "Visual", timeout = 150 })
  end,
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

    if vim.lsp.inline_completion and client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlineCompletion, buf) then
      vim.lsp.inline_completion.enable(true, { bufnr = buf })
      map("<C-f>", vim.lsp.inline_completion.get, "Accept inline completion", "i")
      map("<C-g>", vim.lsp.inline_completion.select, "Next inline completion", "i")
    end

    if client and client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = buf })
    end
  end,
})
