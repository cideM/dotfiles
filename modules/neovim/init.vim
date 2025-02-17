" https://neovim.io/doc/user/news.html
packadd cfilter

let g:loaded_gzip = 1
let g:loaded_zip = 1
let g:loaded_zipPlugin = 1
let g:loaded_tar = 1
let g:loaded_tarPlugin = 1
let g:loaded_vimball = 1
let g:loaded_vimballPlugin = 1

set number
set numberwidth=3
set statuscolumn=%l\ %s\ %C
set signcolumn=yes:1
set background=light
set exrc
set foldmethod=indent
set expandtab
set tabstop=4
set shiftwidth=2
set timeoutlen=500
set diffopt=internal,filler,closeoff,algorithm:minimal
set colorcolumn=+0
set cursorline
set formatoptions+=r
set mouse=a
set ignorecase
set smartcase
set wildignore+=*.git/*,*.min.*,./result/*
  \,*.map,*.idea,*build/*,.direnv/*,*dist/*,*compiled/*,*tmp/*
set inccommand=split
set completeopt+=popup,fuzzy
set complete=.,b,u
set splitbelow
set splitright
set foldlevelstart=99
set undofile
set termguicolors
set grepprg=rg\ -H\ --vimgrep\ --smart-case
set path-=/usr/include
set list
set listchars=eol:¬,space:\ ,lead:\ ,trail:␣,nbsp:◇,tab:⇥\ ,extends:❯,precedes:❮,multispace:\·\ \ \,leadmultispace:\┊\ \ \ ,
set statusline=\ %f\ %m%=\ %y\ %q\ %3l:%2c\ \|%3p%%\ 

" COLOR STUFF
let g:yui_lightline = v:true
let g:yui_comments = 'fade'
colorscheme yui

lua <<EOF
  if vim.fn.executable("defaults") == 1 then
    local appleInterfaceStyle = vim.fn.system({"defaults", "read", "-g", "AppleInterfaceStyle"})
    if appleInterfaceStyle:find("Dark") then
      vim.cmd("source ~/private/yui/colors/yui_dark.vim")
      vim.o.background = 'dark'
    else
      vim.cmd("source ~/private/yui/colors/yui.vim")
      vim.o.background = 'light'
    end
  end
EOF

" let g:lightline = {
" \ 'colorscheme': 'yui'
" \ }

au BufNewFile,BufRead Jenkinsfile* setf groovy

aug terminsert | exe "au! TermOpen * startinsert | setl nonu nornu" | aug END

aug quickfix
    au!
    au QuickFixCmdPost [^l]* cwindow
    au QuickFixCmdPost l* lwindow
aug END

aug highlight_yank | exe "au! TextYankPost * silent! lua require'vim.highlight'.on_yank()" | aug END

" Won't work on linux
command! -nargs=1 Browse silent execute '!open' shellescape(<q-args>,1)

" Timestamp with 2024-11-28 14:35:55
iab <expr> tds strftime("%F %T")

lua require('gitsigns').setup()
nnoremap H :Gitsigns preview_hunk<CR>
nnoremap ]c :Gitsigns next_hunk<CR>
nnoremap [c :Gitsigns prev_hunk<CR>

set fillchars+=vert:│

let mapleader = " "
let maplocalleader = ","

imap     jk        <Esc>
tnoremap <Esc>     <C-\><C-n>
nnoremap <leader>w :silent update<cr>

vnoremap <leader>y  "+y
nnoremap <leader>Y  "+yg_
nnoremap <leader>y  "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P

lua <<EOF
require('leap').create_default_mappings()
EOF

let g:sandwich_no_default_key_mappings = 1
" add
nmap za <Plug>(sandwich-add)
xmap za <Plug>(sandwich-add)
omap za <Plug>(sandwich-add)

" delete
nmap zd <Plug>(sandwich-delete)
xmap zd <Plug>(sandwich-delete)
nmap zdb <Plug>(sandwich-delete-auto)

" replace
nmap zr <Plug>(sandwich-replace)
xmap zr <Plug>(sandwich-replace)
nmap zrb <Plug>(sandwich-replace-auto)

let g:conjure#filetypes = ["clojure", "fennel", "janet", "scheme", "racket", "lisp"]
let g:conjure#log#hud#anchor="SE"
let g:conjure#log#hud#width=1
let g:conjure#log#wrap=v:true

vnoremap <leader>gl :<C-U>execute ':Git log -L' . line("'<") . ',' . line("'>") . ':%'<CR>

" ======= sad =======================
map      <leader>C <Plug>(sad-change-backward)
map      <leader>c <Plug>(sad-change-forward)

nnoremap <leader>T :split<bar>lcd %:p:h<bar>term fish<CR>
nnoremap <leader>o :split<bar>term fish<CR>

autocmd TextYankPost * silent! lua vim.hl.on_yank {higroup='Visual', timeout=300}

lua <<EOF

local fzfLua = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', fzfLua.files, {
  desc = "fzf-lua files"
})
vim.keymap.set('n', '<leader>fb', fzfLua.buffers, {
  desc = "fzf-lua buffers"
})
vim.keymap.set('n', '<leader>fl', fzfLua.blines, {
  desc = "fzf-lua current buffer lines"
})
vim.keymap.set('n', '<leader>sw', fzfLua.grep_cword, {
  desc = "fzf-lua search word under cursor"
})
vim.keymap.set('v', '<leader>sv', fzfLua.grep_visual, {
  desc = "fzf-lua search visual selection"
})
vim.keymap.set('n', '<leader>sp', fzfLua.live_grep_native, {
  desc = "fzf-lua live grep current project (performant version)"
})
vim.keymap.set('n', '<leader>lr', fzfLua.lsp_references, {
  desc = "fzf-lua LSP references"
})
vim.keymap.set('n', '<leader>ld', fzfLua.lsp_definitions, {
  desc = "fzf-lua LSP definitions"
})
vim.keymap.set('n', '<leader>li', fzfLua.lsp_implementations, {
  desc = "fzf-lua LSP implementations"
})
vim.keymap.set('n', '<leader>ls', fzfLua.lsp_document_symbols, {
  desc = "fzf-lua LSP document symbols"
})
vim.keymap.set('n', '<leader>lw', fzfLua.lsp_live_workspace_symbols, {
  desc = "fzf-lua LSP live workspace symbols"
})
vim.keymap.set('n', '<leader>la', fzfLua.lsp_code_actions, {
  desc = "fzf-lua LSP code actions"
})

vim.diagnostic.config({
  virtual_text = {
    source = "if_many",
    prefix = "● ",
  },
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    focusable = false,
    focus = false,
    style = "minimal",
    border = "single",
    source = "if_many",
    header = "",
    prefix = "",
  },
})

local nvim_lsp = require'lspconfig'

nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, { on_attach = on_attach })

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", focusable = true })

nvim_lsp.rust_analyzer.setup{}
nvim_lsp.astro.setup{}
nvim_lsp.ts_ls.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("package.json"),
  single_file_support = false,
    init_options = {
      preferences = { includeCompletionsForModuleExports = false }
    }
}
nvim_lsp.gopls.setup{}
nvim_lsp.zls.setup{}
nvim_lsp.lua_ls.setup{}
nvim_lsp.eslint.setup{}
nvim_lsp.biome.setup{}
nvim_lsp.clangd.setup{}
nvim_lsp.ruff.setup {}
nvim_lsp.denols.setup {
  on_attach = on_attach,
  root_dir = nvim_lsp.util.root_pattern("deno.json", "deno.jsonc"),
}

require'treesitter-context'.setup{
  enable = true,
  max_lines = 8,
  multiwindow = true
}

require'nvim-treesitter.configs'.setup {
  ensure_installed = {},
  highlight = {
    enable = true,
    disable = {"help", "gitcommit"},
  },
  incremental_selection = {
    enable = true,
  },
  indent = {
    enable = true,
    disable = {},
  },
}

EOF
