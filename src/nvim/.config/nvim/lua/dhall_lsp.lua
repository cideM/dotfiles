local nvim_lsp = require'nvim_lsp'
local configs = require'nvim_lsp/configs'
-- Check if it's already defined for when I reload this file.

configs.dhall = {
    default_config = {
          cmd = {'dhall-lsp-server'};
          filetypes = {'dhall'};
          root_dir = function(fname)
                return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
          end;
          settings = {};
    };
}

nvim_lsp.dhall.setup{}
