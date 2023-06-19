args@{ config
, lib
, pkgs
, ...
}:

with lib;
with types;
let

  makeFtPlugins = ftplugins: with attrsets;
    mapAttrs'
      (key: value: nameValuePair "nvim/after/ftplugin/${key}.vim" ({ text = value; }))
      ftplugins;
in
{
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
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      purescript = ''
        setl formatprg=purty\ format\ -
      '';
      json = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      yaml = ''
        setl formatprg=prettier\ --stdin-filepath\ %
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
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
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      typescript = ''
        compiler tsc
        setl formatexpr=
        setl formatprg=prettier\ --parser\ typescript\ --stdin-filepath\ %
        setl wildignore+=*node_modules*,package-lock.json,yarn-lock.json
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
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
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
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
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
        set formatprg=stylua\ -
      '';
      python = ''
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
      '';
      sql = ''
        setl formatprg=pg_format\ -g
      '';
      go = ''
        compiler go
        function! GoImports()
            let saved = winsaveview()
            %!goimports
            call winrestview(saved)
        endfunction
        nnoremap <buffer> <localleader>i :call GoImports()<cr>
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
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

        set background=light
        set foldmethod=indent
        set expandtab
        set tabstop=2
        set shiftwidth=2
        set timeoutlen=500
        set colorcolumn=+0
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

        nnoremap <leader>/ :nohlsearch<CR>

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

        " ======= sandwich ==================
        let g:sandwich_no_default_key_mappings = 1
        silent! nmap <unique><silent> gd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> gr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> gdb <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
        silent! nmap <unique><silent> grb <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

        let g:operator_sandwich_no_default_key_mappings = 1
        silent! map <unique> ga <Plug>(operator-sandwich-add)
        silent! xmap <unique> gd <Plug>(operator-sandwich-delete)
        silent! xmap <unique> gr <Plug>(operator-sandwich-replace)

        silent! omap <unique> ib <Plug>(textobj-sandwich-auto-i)
        silent! xmap <unique> ib <Plug>(textobj-sandwich-auto-i)
        silent! omap <unique> ab <Plug>(textobj-sandwich-auto-a)
        silent! xmap <unique> ab <Plug>(textobj-sandwich-auto-a)

        silent! omap <unique> iq <Plug>(textobj-sandwich-query-i)
        silent! xmap <unique> iq <Plug>(textobj-sandwich-query-i)
        silent! omap <unique> aq <Plug>(textobj-sandwich-query-a)
        silent! xmap <unique> aq <Plug>(textobj-sandwich-query-a)

        silent! xmap <unique> im <Plug>(textobj-sandwich-literal-query-i)
        silent! xmap <unique> am <Plug>(textobj-sandwich-literal-query-a)
        silent! omap <unique> im <Plug>(textobj-sandwich-literal-query-i)
        silent! omap <unique> am <Plug>(textobj-sandwich-literal-query-a)

        " ======= lsp =======================
        lua <<EOF

        vim.loader.enable()

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
        vim.keymap.set('n', '<leader>ps', vim.diagnostic.open_float, bufopts)
        vim.keymap.set('n', '<leader>pl', vim.diagnostic.setloclist, bufopts)

        local nvim_lsp = require'lspconfig'

        local on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        end

        local configs = require'lspconfig/configs'

        nvim_lsp.util.default_config = vim.tbl_extend("force", nvim_lsp.util.default_config, { on_attach = on_attach })

        vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

        nvim_lsp.rust_analyzer.setup{}
        nvim_lsp.tsserver.setup{}
        nvim_lsp.gopls.setup{}
        nvim_lsp.zls.setup{}
        nvim_lsp.lua_ls.setup{}
        nvim_lsp.eslint.setup{}

        require('lspfuzzy').setup {}

        require('leap').add_default_mappings()

        -- Treesitter
        require'nvim-treesitter.configs'.setup {
          ensure_installed = {},
          highlight = {
            enable = true,
            disable = {"help", "gitcommit"},
          },
          incremental_selection = {
            enable = false,
          },
          indent = {
            enable = true,
            disable = {},
          },
        }

        EOF
      '';

      plugins = with pkgs.vimPlugins; [
        # LSP
        nvim-lspconfig
        lspfuzzy

        # Git
        vim-fugitive
        vim-rhubarb

        vim-unimpaired
        vim-repeat
        vim-commentary
        vim-indent-object
        QFEnter
        fzfWrapper
        fzf-vim
        vim-gutentags
        leap-nvim
        vim-sandwich
        sad-vim
        copilot-vim

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
        nvim-treesitter.withAllGrammars

      ];
    };
  };
}

