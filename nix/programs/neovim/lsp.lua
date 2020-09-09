local nvim_lsp = require('nvim_lsp')
local buf_set_keymap = vim.api.nvim_buf_set_keymap

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap(bufnr, 'n', '<localleader>k',  '<cmd>lua vim.lsp.buf.hover()<CR>',                 opts)
    buf_set_keymap(bufnr, 'n', '<localleader>h',  '<cmd>lua vim.lsp.buf.signature_help()<CR>',        opts)
    buf_set_keymap(bufnr, 'n', '<localleader>re', '<cmd>lua vim.lsp.buf.rename()<CR>',                opts)
    buf_set_keymap(bufnr, 'n', '<localleader>rr', '<cmd>lua vim.lsp.buf.references()<CR>',            opts)
    buf_set_keymap(bufnr, 'n', '<localleader>ri', '<cmd>lua vim.lsp.buf.implementation()<CR>',        opts)
    buf_set_keymap(bufnr, 'n', '<localleader>dd', '<cmd>lua vim.lsp.buf.definition()<CR>',            opts)
    buf_set_keymap(bufnr, 'n', '<localleader>dt', '<cmd>lua vim.lsp.buf.type_definition()<CR>',       opts)
    buf_set_keymap(bufnr, 'n', '<localleader>dc', '<cmd>lua vim.lsp.buf.declaration()<CR>',           opts)
    buf_set_keymap(bufnr, 'n', '<localleader>p',  '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>',opts)
end

local configs = require'nvim_lsp/configs'

configs.dhall = {
    default_config = {
            cmd = {'${pkgs.haskellPackages.dhall-lsp-server}/bin/dhall-lsp-server'};
            filetypes = {'dhall'};
            root_dir = function(fname)
                return nvim_lsp.util.find_git_ancestor(fname) or vim.loop.os_homedir()
            end;
            settings = {};
    };
}

local servers = {'gopls', 'rust_analyzer', 'dhall', 'purescriptls'}

for _, lsp in ipairs(servers) do
    if nvim_lsp[lsp].setup ~= nil then
      nvim_lsp[lsp].setup { on_attach = on_attach }
    end
end