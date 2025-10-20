vim.cmd.packadd("cfilter") -- quickfix filtering with :Cfilter and :Lfilter

-- prevent loading code that I never use
vim.g.loaded_gzip = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1

vim.o.number = false
vim.o.winborder = "rounded"
vim.o.numberwidth = 3
vim.o.linebreak = true
vim.o.statuscolumn = "%l %s %C"
vim.o.statusline = " %f %m%= %y %q %3l:%2c |%3p%% "
vim.o.background = "light"
vim.o.exrc = true
vim.o.foldmethod = "indent"
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 2
vim.o.timeoutlen = 500
vim.opt.diffopt = { internal = true, filler = true, closeoff = true, algorithm = "myers" }
vim.o.colorcolumn = "+0"
vim.o.cursorline = true
vim.opt.formatoptions:append("r")
vim.o.mouse = "a"
vim.o.ignorecase = true
vim.o.smartcase = true
vim.opt.wildignore:append({
  "*.git/*",
  "*.min.*",
  "./result/*",
  "*.map",
  "*.idea",
  "*build/*",
  ".direnv/*",
  "*dist/*",
  "*compiled/*",
  "*tmp/*",
})
vim.o.inccommand = "split"
vim.opt.completeopt:append({ "fuzzy", "noselect" })
vim.opt.completeopt:remove({ "popup" })
vim.opt.complete = { ".", "b", "u" }
vim.o.signcolumn = "auto:1"
vim.o.splitbelow = true
vim.o.splitright = true
vim.o.foldlevelstart = 99
vim.o.undofile = true
vim.o.termguicolors = true
vim.o.grepprg = "rg -H --vimgrep --smart-case"
vim.opt.path:remove("/usr/include")
vim.o.list = true
vim.opt.fillchars:append({ vert = "│" })
vim.opt.fillchars:append({ eob = " " })
vim.opt.listchars = {
  eol = "¬",
  space = " ",
  lead = " ",
  trail = "␣",
  nbsp = "◇",
  tab = "⇥ ",
  extends = "❯",
  precedes = "❮",
  multispace = "·  ",
  leadmultispace = "┊  ",
}

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.g.yui_lightline = true
vim.g.yui_comments = "fade"
vim.cmd.colorscheme("yui")

vim.lsp.enable("denols")
vim.lsp.enable("gopls")
vim.lsp.enable("zls")
vim.lsp.enable("ts_ls")
vim.lsp.enable("eslint")

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

vim.keymap.set("n", "<leader>g", fzfLua.global, {
  desc = "fzf-lua global picker (no prefix -> files, $ -> buffers, @ -> symbols -> # global symbols)",
})

vim.keymap.set("n", "<leader>ff", fzfLua.files, {
  desc = "fzf-lua files",
})

vim.keymap.set("n", "<leader>fb", fzfLua.buffers, {
  desc = "fzf-lua buffers",
})

vim.keymap.set("n", "<leader>fg", fzfLua.live_grep_native, {
  desc = "fzf-lua live grep current project (performant version)",
})

vim.keymap.set("n", "<leader>fr", fzfLua.lsp_references, {
  desc = "fzf-lua LSP references",
})

vim.keymap.set("n", "<leader>fs", fzfLua.lsp_document_symbols, {
  desc = "fzf-lua LSP document symbols",
})

vim.keymap.set("n", "<leader>fw", fzfLua.lsp_live_workspace_symbols, {
  desc = "fzf-lua LSP live workspace symbols",
})

vim.keymap.set("n", "<leader>fi", fzfLua.lsp_live_workspace_symbols, {
  desc = "fzf-lua LSP live workspace symbols",
})

vim.keymap.set("n", "<leader>fa", fzfLua.lsp_code_actions, {
  desc = "fzf-lua LSP code actions",
})

vim.keymap.set({ "n", "v", "i" }, "<C-x><C-f>", function()
  fzfLua.complete_path()
end, { silent = true, desc = "Fuzzy complete path" })

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
    if client:supports_method("textDocument/completion") then
      vim.lsp.completion.enable(true, client.id, args.buf, {
        autotrigger = true,
      })
    end
  end,
})

local flash = require("flash")
flash.setup()

vim.keymap.set({ "n", "x", "o" }, "s", function()
  require("flash").jump()
end, { desc = "Flash" })

vim.keymap.set({ "n", "x", "o" }, "S", function()
  require("flash").treesitter()
end, { desc = "Flash Treesitter" })

vim.keymap.set("o", "r", function()
  flash.remote()
end, { desc = "Remote Flash" })

vim.keymap.set("c", "<c-s>", function()
  flash.toggle()
end, { desc = "Toggle Flash Search" })

vim.g.sandwich_no_default_key_mappings = 1

-- add
vim.keymap.set("n", "za", "<Plug>(sandwich-add)", { desc = "Sandwich add operator" })
vim.keymap.set("x", "za", "<Plug>(sandwich-add)", { desc = "Sandwich add in visual mode" })
vim.keymap.set("o", "za", "<Plug>(sandwich-add)", { desc = "Sandwich add in operator pending mode" })

-- delete
vim.keymap.set("n", "zd", "<Plug>(sandwich-delete)", { desc = "Sandwich delete operator" })
vim.keymap.set("x", "zd", "<Plug>(sandwich-delete)", { desc = "Sandwich delete in visual mode" })
vim.keymap.set("n", "zdb", "<Plug>(sandwich-delete-auto)", { desc = "Sandwich auto delete" })

-- replace
vim.keymap.set("n", "zr", "<Plug>(sandwich-replace)", { desc = "Sandwich replace operator" })
vim.keymap.set("x", "zr", "<Plug>(sandwich-replace)", { desc = "Sandwich replace in visual mode" })
vim.keymap.set("n", "zrb", "<Plug>(sandwich-replace-auto)", { desc = "Sandwich auto replace" })

vim.diagnostic.config({
  virtual_text = false,
  virtual_lines = false,
})

if vim.fn.executable("defaults") == 1 then
  local appleInterfaceStyle = vim.fn.system({ "defaults", "read", "-g", "AppleInterfaceStyle" })
  if appleInterfaceStyle:find("Dark") then
    vim.cmd("source ~/private/yui/colors/yui_dark.vim")
    vim.o.background = "dark"
  else
    vim.cmd("source ~/private/yui/colors/yui.vim")
    vim.o.background = "light"
  end
end

if vim.uv.os_uname().sysname == "Darwin" then
  vim.api.nvim_create_user_command("Browse", function(t)
    local args = table.concat(t.fargs, " ")
    vim.fn.system("open " .. args)
  end, {
    desc = "Call the MacOS 'open' utility on the given string",
    nargs = 1,
  })
end

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
  pattern = { "Jenkinsfile*" },
  callback = function()
    vim.cmd.setf("groovy")
  end,
  desc = "Set groovy filetype in Jenkinsfile",
})

vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = { "*" },
  callback = function()
    vim.cmd.startinsert()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
  desc = "Settings for terminal windows",
})

vim.api.nvim_create_autocmd({ "QuickFixCmdPost" }, {
  pattern = { "[^l]*", "l*" },
  callback = function()
    vim.cmd.cwindow()
  end,
  desc = "Open the quickfix window",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  pattern = { "*" },
  callback = function()
    vim.hl.on_yank({ higroup = "CurSearch", timeout = 300 })
  end,
})

vim.keymap.set("n", "<BS>", "<C-^>", {
  desc = "Switch to most recent buffer",
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("n", "<C-f>", function()
  require("conform").format()
end, {
  desc = "format the buffer with LSP",
})

require("treesitter-context").setup({
  enable = true,
  max_lines = 4,
  multiwindow = true,
})

-- Terminal
vim.keymap.set("n", "<leader>tv", ":vert term fish<CR>", {
  desc = "Open terminal in a vertical split (to the side)",
})

vim.keymap.set("n", "<leader>tt", ":hor term fish<CR>", {
  desc = "Open terminal in a horizontal split (down)",
})

vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<leader>w", function()
  vim.cmd("silent update")
end, { desc = "Save file silently" })

-- System clipboard operations
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selection to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+yg_', { desc = "Copy from cursor to end of line to system clipboard" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Copy to system clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard after cursor" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste from system clipboard before cursor" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from system clipboard after selection" })
vim.keymap.set("v", "<leader>P", '"+P', { desc = "Paste from system clipboard before selection" })

vim.g["conjure#filetypes"] = { "clojure", "fennel", "janet", "scheme", "racket", "lisp" }
vim.g["conjure#log#hud#anchor"] = "SE"
vim.g["conjure#log#hud#width"] = 1
vim.g["conjure#log#wrap"] = true

vim.keymap.set("v", "<leader>gl", function()
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")
  vim.cmd("Git log -L" .. start_line .. "," .. end_line .. ":%")
end, { desc = "Git log for selected line range" })

vim.keymap.set("", "<leader>C", "<Plug>(sad-change-backward)", { desc = "Sad change backward" })
vim.keymap.set("", "<leader>c", "<Plug>(sad-change-forward)", { desc = "Sad change forward" })

require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua", lsp_format = "fallback" },
    go = { "goimports", "gofmt" },
    rust = { "rustfmt" },
    nix = { "nixfmt" },
    ts = { "biome-organize-imports", "biome", "prettier" },
    tsx = { "biome-organize-imports", "biome", "prettier" },
    typescript = { "biome-organize-imports", "biome", "prettier" },
    typescriptreact = { "biome-organize-imports", "biome", "prettier" },
    js = { "biome-organize-imports", "biome", "prettier" },
    jsx = { "biome-organize-imports", "biome", "prettier" },
    javascript = { "biome-organize-imports", "biome", "prettier" },
    json = { "jq" },
    bash = { "shfmt" },
    xml = { "xmllint" },
    zig = { "zigfmt" },
  },
  default_format_opts = {
    lsp_format = "never",
    timeout_ms = 1000,
  },
  log_level = vim.log.levels.DEBUG,
  format_on_save = {
    lsp_format = "never",
  },
})

vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"

vim.keymap.set("n", "<C-f>", function()
  require("conform").format()
end, {
  desc = "format the buffer with LSP",
})

require("nvim-treesitter.configs").setup({
  ensure_installed = {},
  highlight = {
    enable = true,
    disable = { "help", "gitcommit" },
  },
  incremental_selection = {
    enable = false,
    keymaps = {
      init_selection = "gn",
      node_incremental = "<TAB>",
      node_decremental = "<S-TAB>",
      scope_incremental = "gn",
    },
  },
  indent = {
    enable = false,
    disable = {},
  },
  textobjects = {
    select = {
      enable = false,
      lookahead = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@comment.outer",
        ["ic"] = "@comment.inner",
      },
    },
    swap = {
      enable = false,
      swap_next = {
        ["<leader>a"] = "@parameter.inner",
      },
      swap_previous = {
        ["<leader>A"] = "@parameter.inner",
      },
    },
    lsp_interop = {
      enable = false,
      border = "none",
      floating_preview_opts = {},
      peek_definition_code = {
        ["<leader>df"] = "@function.outer",
        ["<leader>dF"] = "@class.outer",
      },
    },
  },
})

vim.keymap.set("n", "<leader>r", function()
  vim.ui.input({ prompt = "shell commandline: " }, function(str)
    if str and str ~= "" then
      vim.cmd("noswapfile vnew")
      vim.bo.buftype = "nofile"
      vim.bo.bufhidden = "wipe"
      vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.fn.systemlist(str))
    end
  end)
end)

function findFuncFd(file)
  local cmdstr = "fd --type file --full-path --color never " .. file
  return vim.fn.systemlist(cmdstr)
end

vim.o.findfunc = "v:lua.findFuncFd"
