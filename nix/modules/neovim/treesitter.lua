require'nvim-treesitter.configs'.setup {
  ensure_installed = {},     -- one of "all", "language", or a list of languages
  highlight = {
    enable = false,              -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
  },
}
