vim.cmd.compiler("eslint")

if vim.fn.executable("deno") == 1 then
  vim.opt_local.makeprg = "deno lint %"
else
  vim.opt_local.makeprg = "eslint --format compact"
end
