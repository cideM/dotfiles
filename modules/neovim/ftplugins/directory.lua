-- Listings are 'buflisted', so browsing otherwise leaves them behind in the
-- buffer list. Discarding on hide costs the remembered cursor position.
vim.bo.bufhidden = "delete"

-- Open the entry under the cursor in a split, dirvish-style. Splitting first
-- leaves the cursor on the same line, so the builtin mapping does the work.
vim.keymap.set("n", "o", "<C-w>s<Plug>(nvim-dir-open)", {
  buffer = true,
  remap = true,
  desc = "Open entry in a horizontal split",
})
vim.keymap.set("n", "a", "<C-w>v<Plug>(nvim-dir-open)", {
  buffer = true,
  remap = true,
  desc = "Open entry in a vertical split",
})
