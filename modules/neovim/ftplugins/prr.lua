-- prr review files (https://github.com/danobi/prr). The plugin folds every
-- file and hunk closed on open; start with everything visible instead.
vim.opt_local.foldenable = false

-- Colour the quoted diff like a regular git diff: link each prr group to the
-- group the `diff` filetype uses for the same line. The colorscheme styles
-- those (diffAdded, diffRemoved, diffLine); the rest only get their defaults
-- when syntax/diff.vim has run, so define the same defaults here in case a
-- prr file is the first diff opened.
local groups = {
  -- prr group, diff group, default from syntax/diff.vim
  { "prrAdded", "diffAdded", "Added" },
  { "prrRemoved", "diffRemoved", "Removed" },
  { "prrHeader", "diffFile", "Type" },
  { "prrIndex", "diffIndexLine", "PreProc" },
  { "prrChunkH", "diffLine", "Statement" },
}
for _, g in ipairs(groups) do
  local prr, diff, default = g[1], g[2], g[3]
  vim.api.nvim_set_hl(0, diff, { link = default, default = true })
  vim.api.nvim_set_hl(0, prr, { link = diff })
end
