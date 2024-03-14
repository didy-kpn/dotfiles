return {
  "nvim-treesitter/nvim-treesitter",
  opts = {
    run = ":TSUpdate",
    ensure_installed = {
      "javascript",
      "javascript",
      "css",
      "gitignore",
      "graphql",
      "http",
      "json",
      "scss",
      "sql",
      "vim",
      "lua",
      "sql",
      "rust",
      "php",
      "bash",
      "html",
    },
    query_linter = {
      enable = true,
      use_virtual_text = true,
      lint_events = { "BufWrite", "CursorHold" },
    },
  },
}
