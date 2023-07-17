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
      json = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      yaml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
      '';
      fzf = ''
        setl laststatus=0 noshowmode noruler
        aug fzf | au! BufLeave <buffer> set laststatus& showmode ruler | aug END
      '';
      javascript = ''
        compiler eslint
        setl formatprg=prettier\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        setl makeprg=eslint\ --format\ compact
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
        setl formatprg=prettier\ --parser\ scss\ --stdin-filepath\ %
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
        set formatprg=gofmt
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

        let g:loaded_gzip = 1
        let g:loaded_netrw = 1
        let g:loaded_netrwPlugin = 1
        let g:loaded_netrwSettings = 1
        let g:loaded_zip = 1
        let g:loaded_zipPlugin = 1
        let g:loaded_tar = 1
        let g:loaded_tarPlugin = 1
        let g:loaded_vimball = 1
        let g:loaded_vimballPlugin = 1

        set background=light
        set foldmethod=indent
        set expandtab
        set tabstop=2
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
        set splitbelow
        set splitright
        set foldlevelstart=99
        set undofile
        set termguicolors
        set grepprg=rg\ -H\ --vimgrep\ --smart-case
        set grepformat=%f:%l:%c:%m
        set path-=/usr/include
        set list
        set listchars=eol:¬,space:\ ,lead:\ ,trail:·,nbsp:◇,tab:→\ ,extends:❯,precedes:❮,multispace:\·\ \ \,leadmultispace:\│\ \ \ ,
        set statusline+=\ %f\ %m%=\ %y\ %q\ %3l:%2c\ \|%3p%%\ 

        " COLOR STUFF
        let g:yui_comments = 'bg'
        let g:yui_lightline = v:true
        colorscheme yui

        let g:gutentags_exclude_filetypes = ["haskell", "purs", "purescript", "git", "gitcommit"]
        let g:gutentags_file_list_command = 'rg --files'
        let g:gutentags_ctags_executable = '${pkgs.universal-ctags}/bin/ctags'

        function! SynGroup()
            let l:s = synID(line('.'), col('.'), 1)
            echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
        endfun

        aug terminsert | exe "au! TermOpen * startinsert | setl nonu nornu" | aug END

        aug quickfix
            au!
            au QuickFixCmdPost [^l]* cwindow
            au QuickFixCmdPost l* lwindow
        aug END

        aug highlight_yank | exe "au! TextYankPost * silent! lua require'vim.highlight'.on_yank()" | aug END

        let mapleader = " "
        let maplocalleader = ","

        imap     jk        <Esc>
        tnoremap <Esc>     <C-\><C-n>
        nnoremap <BS>      <C-^>
        nnoremap <Leader>q :Sayonara!<CR>
        nnoremap <Leader>Q :Sayonara<CR>
        nnoremap <leader><leader> :update<cr>
        " https://github.com/junegunn/fzf.vim/pull/628
        " TODO: this should consider what's before the cursor in case that is a valid path
        inoremap <expr> <c-x><c-f> fzf#vim#complete("rg --files --hidden --no-ignore --null <Bar> xargs --null realpath --relative-to " . expand("%:h"))

        " ======= fzf =======================
        let g:fzf_preview_window = ['up:60%', 'ctrl-/']
        let g:fzf_layout = { 'window': { 'width': 0.8, 'height': 0.8 } }
        nnoremap <leader>f :Files<cr>
        nnoremap <leader>l :BLines<cr>
        nnoremap <leader>t :Tags<cr>
        nnoremap <leader>m :Marks<cr>
        nnoremap <leader>b :Buffers<cr>
        nnoremap <leader>W :Windows<cr>

        nmap     <leader>F :call FormatBuffer()<cr>

        nnoremap <leader>T :split<bar>lcd %:p:h<bar>term fish<CR>
        nnoremap <leader>o :split<bar>term fish<CR>

        vnoremap <leader>gl :<C-U>execute ':Git log -L' . line("'<") . ',' . line("'>") . ':%'<CR>

        " ======= sad =======================
        map      <leader>C <Plug>(sad-change-backward)
        map      <leader>c <Plug>(sad-change-forward)

        " ======= copilot ==================
        imap <S-Tab> <Plug>(copilot-suggest)
        imap <C-j> <Plug>(copilot-next)
        imap <C-h> <Plug>(copilot-previous)
        imap <C-d> <Plug>(copilot-dismiss)

        let g:lightline = {
        \ 'colorscheme': 'yui'
        \ }

        lua require("nvim-surround").setup {}

        lua require('lspfuzzy').setup {}

        lua require('gitsigns').setup()

        lua require('leap').add_default_mappings()

        " ======= lsp =======================
        lua <<EOF
        require("terminal").setup({
          layout = { border = "rounded", open_cmd = "float", height = 0.8, width = 0.6 },
          cmd = { vim.o.shell },
        })
        local term_map = require("terminal.mappings")
        vim.keymap.set("n", "<leader>to", term_map.toggle)
        vim.keymap.set("n", "<leader>tt", term_map.run(vim.o.shell))
        vim.keymap.set("n", "<leader>tk", term_map.kill)
        vim.keymap.set("n", "<leader>t]", term_map.cycle_next)
        vim.keymap.set("n", "<leader>t[", term_map.cycle_prev)

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

        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'Q', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<leader>i', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', '<leader>R', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<C-f>', function() vim.lsp.buf.format { async = false } end, bufopts)
        vim.keymap.set('n', '<leader>s', vim.lsp.buf.document_symbol, bufopts)
        vim.keymap.set('n', '<leader>S', vim.lsp.buf.workspace_symbol, bufopts)
        vim.keymap.set('n', '<C-n>', function () vim.diagnostic.goto_next{ float = true } end, bufopts)
        vim.keymap.set('n', '<C-p>', function () vim.diagnostic.goto_prev{ float = true } end, bufopts)
        vim.keymap.set('n', '<leader>ps', function () vim.diagnostic.open_float({ pad_top = 0, pad_bottom = 0, border = "single" }) end, bufopts)
        vim.keymap.set('n', '<leader>pl', vim.diagnostic.setloclist, bufopts)

        local nvim_lsp = require'lspconfig'

        local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        end

        nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, { on_attach = on_attach })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

        nvim_lsp.rust_analyzer.setup{}
        nvim_lsp.tsserver.setup{}
        nvim_lsp.gopls.setup{}
        nvim_lsp.zls.setup{}
        nvim_lsp.lua_ls.setup{}
        nvim_lsp.eslint.setup{}

        EOF
      '';

      plugins = with pkgs.vimPlugins; [
        # LSP
        nvim-lspconfig
        lspfuzzy

        # Git
        vim-fugitive
        vim-rhubarb
        gitsigns-nvim

        vim-unimpaired
        azabiong-vim-highlighter
        vim-repeat
        vim-commentary
        vim-indent-object
        QFEnter
        fzfWrapper
        fzf-vim
        vim-gutentags
        vim-dirvish
        leap-nvim
        nvim-surround
        sad-vim
        copilot-vim
        lightline-vim
        vim-sayonara
        terminal

        # Themes
        edge
        spacevim
        yui
        rose-pine
        everforest
        catppuccin-nvim

        # Syntax
        haskell-vim
        dhall-vim
        zig-vim
        Jenkinsfile-vim-syntax
        purescript-vim
        vim-js
        vim-lua
        vim-jsx-pretty
        vim-nix
        vim-terraform
      ];
    };
  };
}
