return {
  -- MASON
  "williamboman/mason.nvim",
  opts = function(_, opts)
    vim.list_extend(opts.ensure_installed, {
      "luacheck",
      "shellcheck",
      "shfmt",
      "tailwindcss-language-server",
      "typescript-language-server",
      "css-languageserver",
      "rust-analyzer",
      "phpactor",
      "sqls",
      "sqlfmt",
    })
  end,
  -- LSP Servers
  {
    "neovim/nvim-lspconfig",
    opts = {
      inalay_hints = { enabled = true },
      servers = {},
    },
    setup = {},
  },
  {
    "nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-emoji",
    },
    opts = function(_, opts)
      table.insert(opts.sources, { name = "emoji" })
    end,
  },
}
