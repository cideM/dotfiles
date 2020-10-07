local nvim_lsp = require('nvim_lsp')
local buf_set_keymap = vim.api.nvim_buf_set_keymap
local api = vim.api
local util = require 'vim.lsp.util'

-- https://github.com/neovim/neovim/blob/master/runtime/lua/vim/lsp/callbacks.lua
local onPublishDiagnostics = function(err, method, result, client_id)
  if not result then return end
  local uri = result.uri
  local bufnr = vim.uri_to_bufnr(uri)
  if not bufnr then
    err_message("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
    return
  end

  -- Unloaded buffers should not handle diagnostics.
  --    When the buffer is loaded, we'll call on_attach, which sends textDocument/didOpen.
  --    This should trigger another publish of the diagnostics.
  --
  -- In particular, this stops a ton of spam when first starting a server for current
  -- unloaded buffers.
  if not api.nvim_buf_is_loaded(bufnr) then
    return
  end

  util.buf_clear_diagnostics(bufnr)

  if result.diagnostics then
      for _, v in ipairs(result.diagnostics) do
        v.bufnr = client_id
        v.lnum = v.range.start.line + 1
        v.col = v.range.start.character + 1
        v.text = v.message
      end
      util.set_loclist(result.diagnostics)
  end

  util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
  util.buf_diagnostics_underline(bufnr, result.diagnostics)
  -- util.buf_diagnostics_virtual_text(bufnr, result.diagnostics)
  util.buf_diagnostics_signs(bufnr, result.diagnostics)
  vim.api.nvim_command("doautocmd User LspDiagnosticsChanged")
end

local on_attach = function(_, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    local opts = { noremap=true, silent=true }
    buf_set_keymap(bufnr, 'n', '<localleader>k',  '<cmd>lua vim.lsp.buf.hover()<CR>',                 opts)
    buf_set_keymap(bufnr, 'n', '<localleader>h',  '<cmd>lua vim.lsp.buf.signature_help()<CR>',        opts)
    buf_set_keymap(bufnr, 'n', '<localleader>re', '<cmd>lua vim.lsp.buf.rename()<CR>',                opts)
    buf_set_keymap(bufnr, 'n', '<localleader>rr', '<cmd>lua vim.lsp.buf.references()<CR>',            opts)
    buf_set_keymap(bufnr, 'n', '<localleader>ri', '<cmd>lua vim.lsp.buf.implementation()<CR>',        opts)
    buf_set_keymap(bufnr, 'n', '<localleader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>',            opts)
    buf_set_keymap(bufnr, 'n', '<localleader>gt', '<cmd>lua vim.lsp.buf.type_definition()<CR>',       opts)
    buf_set_keymap(bufnr, 'n', '<localleader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>',           opts)
    buf_set_keymap(bufnr, 'n', '<localleader>p',  '<cmd>lua vim.lsp.util.show_line_diagnostics()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>ws',  '<cmd>lua vim.lsp.buf.workspace_symbol()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>ds',  '<cmd>lua vim.lsp.buf.document_symbol()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>dh',  '<cmd>lua vim.lsp.buf.document_highlight()<CR>',opts)
    buf_set_keymap(bufnr, 'n', '<localleader>sr',  '<cmd>lua vim.lsp.buf.server_ready()<CR>',opts)

    -- vim.api.nvim_command [[autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()]]
    -- vim.api.nvim_command [[autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()]]
    -- vim.api.nvim_command [[autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()]]
end

local configs = require'nvim_lsp/configs'

vim.lsp.callbacks["textDocument/publishDiagnostics"] = onPublishDiagnostics

configs.dhall = {
    default_config = {
            cmd = {'dhall-lsp-server'};
            filetypes = {'dhall'};
            root_dir = function(fname)
                return util.find_git_ancestor(fname) or vim.loop.os_homedir()
            end;
            settings = {};
    };
}

local servers = {'gopls', 'rust_analyzer', 'dhall', 'purescriptls'}

for _, lsp in ipairs(servers) do
    if nvim_lsp[lsp].setup ~= nil and vim.fn.executable(nvim_lsp[lsp].cmd) then
      nvim_lsp[lsp].setup { on_attach = on_attach }
    end
end
