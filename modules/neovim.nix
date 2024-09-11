args @ {
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with types; let
  makeFtPlugins = ftplugins:
    with attrsets;
      mapAttrs'
      (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" {text = value;})
      ftplugins;
in {
  config = {
    xdg.configFile = makeFtPlugins {
      xml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      zig = ''
        compiler zig
      '';
      sh = ''
        compiler shellcheck
      '';
      rust = ''
        compiler rustc
        setl formatprg=rustfmt
      '';
      purescript = ''
        setl formatprg=purty\ format\ -
      '';
      python = ''
        setl formatprg=black\ -q\ -
      '';
      json = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      yaml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      javascript = ''
        compiler eslint
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl makeprg=eslint\ --format\ compact
      '';
      astro = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json,./.astro
      '';
      typescript = ''
        compiler tsc
        setl formatexpr=
        setl formatprg=prettier\ --parser\ typescript\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
      '';
      html = ''
        setl formatprg=prettier\ --parser\ html\ --stdin-filepath\ %
      '';
      css = ''
        setl formatprg=prettier\ --parser\ css\ --stdin-filepath\ %
      '';
      scss = ''
        setl formatprg=prettier\ --parser\ scss
      '';
      nix = ''
        setl formatprg=alejandra\ -q
      '';
      dhall = ''
        setl formatprg=dhall\ format
      '';
      make = ''
        setl noexpandtab
      '';
      graphql = ''
        setl formatprg=prettier\ --parser=graphql
      '';
      lua = ''
        set formatprg=stylua\ -
      '';
      sql = ''
        setl formatprg=pg_format\ -g
      '';
      go = ''
        compiler go
        setl formatprg=gofmt
        function! GoImports()
            let saved = winsaveview()
            %!goimports
            call winrestview(saved)
        endfunction
        nnoremap <buffer> <localleader>i :call GoImports()<cr>
      '';
      haskell = ''
        setl formatprg=ormolu\ --stdin-input-file\ %
      '';
      markdown = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
    };

    programs.neovim = {
      enable = true;

      extraConfig = ''
        " Format the buffer with the current formatprg. Most of the custom code here
        " is just so my jump list isn't cluttered and I always end up at the first
        " line when undoing a FormatBuffer call. See the linked post.
        function! FormatBuffer()
          setl formatexpr=
          let view = winsaveview()
          " https://vim.fandom.com/wiki/Restore_the_cursor_position_after_undoing_text_change_made_by_a_script
          normal ix
          normal x
          try | silent undojoin | catch | endtry
          keepjumps normal ggVGgq
          call winrestview(view)
        endfunction

        packadd cfilter

        let g:loaded_gzip = 1
        let g:loaded_zip = 1
        let g:loaded_zipPlugin = 1
        let g:loaded_tar = 1
        let g:loaded_tarPlugin = 1
        let g:loaded_vimball = 1
        let g:loaded_vimballPlugin = 1

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
        set nonumber
        set ignorecase
        set smartcase
        set wildignore+=*.git/*,*.min.*,./result/*
          \,*.map,*.idea,*build/*,.direnv/*,*dist/*,*compiled/*,*tmp/*
        set inccommand=split
        set completeopt-=preview
        set complete=.,b,u
        set splitbelow
        set splitright
        set foldlevelstart=99
        set undofile
        set termguicolors
        set grepprg=rg\ -H\ --vimgrep\ --smart-case
        set grepformat=%f:%l:%c:%m
        set path-=/usr/include
        set list
        set listchars=eol:¬,space:\ ,lead:\ ,trail:␣,nbsp:◇,tab:⇥\ ,extends:❯,precedes:❮,multispace:\·\ \ \,leadmultispace:\┊\ \ \ ,
        set statusline+=\ %f\ %m%=\ %y\ %q\ %3l:%2c\ \|%3p%%\ 

        " COLOR STUFF
        let g:yui_lightline = v:true
        let g:yui_comments = 'emphasize'
        colorscheme yui

        " let g:lightline = {
        " \ 'colorscheme': 'yui'
        " \ }

        function! SynStack()
          echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
        endfunc
        map gm :call SynStack()<CR>

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

        let mapleader = " "
        let maplocalleader = ","

        imap     jk        <Esc>
        tnoremap <Esc>     <C-\><C-n>
        nnoremap <Leader>q :Sayonara!<CR>
        nnoremap <Leader>Q :Sayonara<CR>
        nnoremap <leader>w :silent update<cr>

        vnoremap <leader>y  "+y
        nnoremap <leader>Y  "+yg_
        nnoremap <leader>y  "+y
        nnoremap <leader>p "+p
        nnoremap <leader>P "+P
        vnoremap <leader>p "+p
        vnoremap <leader>P "+P

        hi! link FzfLuaHeaderBind DiffText
        hi! link FzfLuaHeaderText DiffDelete

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

        lua <<EOF
        require'fzf-lua'.setup {"default",
          winopts = {
            preview = {
              flip_columns = 230,
            },
            backdrop = 80,
          },
          lsp = {
            symbols = {
              symbol_style = 3,
            }
          },
          fzf_opts = {
            ['--no-color'] = "",
          },
        }

        vim.keymap.set({ "i" }, "<C-x><C-f>",
          function()
            require("fzf-lua").complete_file({
              cmd = "rg --files",
              winopts = { preview = { hidden = "nohidden" } }
            })
          end, { silent = true, desc = "Fuzzy complete file" }
        )
        EOF

        inoremap <c-x><c-f> <cmd>lua require("fzf-lua").complete_path()<cr>
        nnoremap <leader>f :lua require('fzf-lua').files()<cr>
        nnoremap <leader>l :lua require('fzf-lua').blines()<cr>
        nnoremap <leader>j :lua require('fzf-lua').jumps()<cr>
        nnoremap <leader>t :lua require('fzf-lua').tags()<cr>
        nnoremap <leader>m :lua require('fzf-lua').marks()<cr>
        nnoremap <leader>b :lua require('fzf-lua').buffers()<cr>
        nnoremap <leader>W :lua require('fzf-lua').live_grep()<cr>
        nnoremap <leader>gc :lua require('fzf-lua').git_commits()<cr>
        nnoremap <leader>gb :lua require('fzf-lua').git_branches()<cr>
        nnoremap <leader>gs :lua require('fzf-lua').git_status()<cr>
        nnoremap <leader>gS :lua require('fzf-lua').git_stash()<cr>

        nmap     <leader>F :call FormatBuffer()<cr>

        vnoremap <leader>gl :<C-U>execute ':Git log -L' . line("'<") . ',' . line("'>") . ':%'<CR>

        " ======= sad =======================
        map      <leader>C <Plug>(sad-change-backward)
        map      <leader>c <Plug>(sad-change-forward)

        " ======= copilot ==================
        imap <S-Tab> <Plug>(copilot-suggest)
        imap <C-j> <Plug>(copilot-next)
        imap <C-h> <Plug>(copilot-previous)
        imap <C-d> <Plug>(copilot-dismiss)

        nnoremap <leader>T :split<bar>lcd %:p:h<bar>term fish<CR>
        nnoremap <leader>o :split<bar>term fish<CR>

        " ======= lsp =======================
        lua <<EOF

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

        local fzflua = require('fzf-lua')
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', '<leader>d', fzflua.lsp_definitions, bufopts)
        vim.keymap.set('n', '<leader>D', fzflua.lsp_declarations, bufopts)
        vim.keymap.set('n', 'Q', fzflua.lsp_typedefs, bufopts)
        vim.keymap.set('n', '<leader>i', fzflua.lsp_implementations, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>a', fzflua.lsp_code_actions, bufopts)
        vim.keymap.set('n', '<leader>R', fzflua.lsp_references, bufopts)
        vim.keymap.set('n', '<C-f>', function() vim.lsp.buf.format { async = false } end, bufopts)
        vim.keymap.set('n', '<leader>s', fzflua.lsp_document_symbols, bufopts)
        vim.keymap.set('n', '<leader>S', fzflua.lsp_live_workspace_symbols, bufopts)

        local nvim_lsp = require'lspconfig'

        local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        end

        nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, { on_attach = on_attach })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single", focusable = true })

        nvim_lsp.rust_analyzer.setup{}
        nvim_lsp.astro.setup{}
        nvim_lsp.tsserver.setup{}
        nvim_lsp.gopls.setup{}
        nvim_lsp.zls.setup{}
        nvim_lsp.lua_ls.setup{}
        nvim_lsp.eslint.setup{}
        nvim_lsp.biome.setup{}
        nvim_lsp.ruff_lsp.setup {}

        require'treesitter-context'.setup{ enable = true }

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
      '';

      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        vim-fugitive
        vim-unimpaired
        vim-repeat
        vim-indent-object
        QFEnter
        nvim-treesitter-context
        vim-rhubarb
        fzf-lua
        zen-mode-nvim
        vim-sandwich
        sad-vim
        vim-dirvish
        leap-nvim
        vim-eunuch
        copilot-vim
        # lightline-vim
        vim-sayonara
        janet-vim
        nvim-treesitter.withAllGrammars

        # Themes
        yui
        github-nvim-theme
        catppuccin-nvim
      ];
    };
  };
}
