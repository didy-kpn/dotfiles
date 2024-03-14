require'nvim-treesitter.configs'.setup {
  ensure_installed = { "bash", "json", "lua", "python", "rust", "toml", "yaml", "graphql" },
  ignore_install = { },
  highlight = {
    enable = true,
    disable = { },
  },
  indent = {
    enable = true,
    disable = { },
  },
}
