-- n2: a second, independent Neovim.
--
-- This file is the entire config for the `n2` command. Plugins are managed by
-- Nix in modules/neovim2.nix, not from here. Keep this separate from your main
-- init.lua so the two editors can diverge freely.

-- GENERAL

vim.cmd.packadd("cfilter") -- quickfix filtering with :Cfilter and :Lfilter
vim.cmd.packadd("nvim.undotree")

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.markdown_folding = 1

vim.o.autocomplete = false
vim.opt.complete = { "w", "o", ".", "b", "u" }
vim.opt.completeopt = { "fuzzy", "noselect", "menuone", "popup" }

vim.o.mouse = "a"
vim.o.exrc = true
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.linebreak = true
vim.o.number = false
vim.o.numberwidth = 3
vim.o.expandtab = true
vim.o.shiftwidth = 2
vim.o.tabstop = 2
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.undofile = true
vim.o.grepprg = "rg -H --vimgrep --smart-case"

vim.o.list = true
vim.opt.fillchars:append({ vert = "│" })
vim.opt.fillchars:append({ eob = " " })
vim.opt.listchars = {
  eol = "¬",
  space = " ",
  lead = " ",
  trail = "␣",
  nbsp = "◇",
  tab = "│ ",
  extends = "❯",
  precedes = "❮",
  multispace = "·  ",
  leadmultispace = "│  ",
}

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = { "*" },
  callback = function()
    vim.hl.on_yank({ higroup = "CurSearch", timeout = 300 })
  end,
})

function FindFuncFd(file)
  local cmdstr = "fd --type file --full-path --color never " .. file
  return vim.fn.systemlist(cmdstr)
end

vim.o.findfunc = "v:lua.FindFuncFd"

-- LSP
vim.lsp.enable("denols")
vim.lsp.enable("gopls")
vim.lsp.enable("zls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")
vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = false,
      })
    end
  end,
})

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
})

-- FZF LUA
local fzfLua = require("fzf-lua")

fzfLua.setup({
  winopts = {
    height = 0.9,
    preview = {
      layout = "flex",
      flip_columns = 150,
    },
  },
})

fzfLua.register_ui_select()

vim.keymap.set("n", "<leader>ff", fzfLua.files, {
  desc = "fzf-lua files",
})

vim.keymap.set("n", "<leader>fb", fzfLua.buffers, {
  desc = "fzf-lua buffers",
})

vim.keymap.set("n", "<leader>fa", fzfLua.lsp_code_actions, {
  desc = "fzf-lua LSP actions",
})

vim.keymap.set("n", "<leader>fd", fzfLua.lsp_definitions, {
  desc = "fzf-lua LSP definitions",
})

vim.keymap.set("n", "<leader>fl", fzfLua.live_grep_native, {
  desc = "fzf-lua performant version of live_grep",
})

vim.keymap.set("n", "<leader>fv", fzfLua.live_grep_native, {
  desc = "fzf-lua grep_visual",
})

vim.keymap.set("n", "<leader>fp", fzfLua.diagnostics_document, {
  desc = "fzf-lua LSP document diagnostics",
})

vim.keymap.set("n", "<leader>fr", fzfLua.lsp_references, {
  desc = "fzf-lua LSP references",
})

vim.keymap.set("n", "<leader>ft", fzfLua.lsp_typedefs, {
  desc = "fzf-lua LSP type definitions",
})

vim.keymap.set("n", "<leader>fi", fzfLua.lsp_implementations, {
  desc = "fzf-lua LSP implementations",
})

vim.keymap.set("n", "<leader>fs", fzfLua.lsp_document_symbols, {
  desc = "fzf-lua LSP document symbols",
})

vim.keymap.set("n", "<leader>fw", fzfLua.lsp_live_workspace_symbols, {
  desc = "fzf-lua LSP live workspace symbols",
})

-- TERMINAL
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd.startinsert()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  desc = "Settings for terminal windows",
})

vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>tv", ":vert term fish<CR>", {
  desc = "Open terminal in a vertical split (to the side)",
})
vim.keymap.set("n", "<leader>tt", ":hor term fish<CR>", {
  desc = "Open terminal in a horizontal split (down)",
})

-- KEYMAPS not specific to plugins
vim.keymap.set("n", "<BS>", "<C-^>", {
  desc = "Switch to most recent buffer",
})

vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

vim.keymap.set("n", "<leader>w", function()
  vim.cmd("silent update")
end, { desc = "Save file silently" })

vim.keymap.set("v", "<leader>gl", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  vim.cmd("Git log -L" .. start_line .. "," .. end_line .. ":%")
end, { desc = "Git log for selected line range" })

vim.keymap.set("n", "<leader>cp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy absolute file path" })

vim.keymap.set("n", "<leader>u", require("undotree").open)

vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+yg_', { desc = "Copy from cursor to end of line to system clipboard" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard after cursor" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste from system clipboard before cursor" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from system clipboard after selection" })
vim.keymap.set("v", "<leader>P", '"+P', { desc = "Paste from system clipboard before selection" })
