args@{ config, lib, pkgs, ... }:

with lib;
with types;
let

  cfg = config.programs.neovim;

  sources = config.sources;
in
{
  config = {
    programs.neovim = {
      enable = true;

      package = pkgs.neovim-unwrapped;

      extraConfig = ''
        set bg=light fdm=indent et ts=2 sw=2 tm=500 noea fo=tcrqjn
        set hid nu scs icm=split sb spr fdls=99 udf tgc ic scs
        set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
        set path-=/usr/include
        set list lcs=trail:¬,tab:\ \ 
        let g:yui_comments = 'bg'
        colorscheme yui

        let g:EditorConfig_max_line_indicator = "exceeding"
        let g:EditorConfig_preserve_formatoptions = 1

        let g:sneak#label      = 1
        let g:sneak#use_ic_scs = 1
        let g:sneak#s_next = 1

        let g:peekaboo_window = 'vert bo 40new'

        let g:gutentags_exclude_filetypes = ["haskell", "purs", "purescript"]
        let g:gutentags_file_list_command = 'rg\ --files'

        " Format the buffer with the current formatprg. Most of the custom code here
        " is just so my jump list isn't cluttered and I always end up at the first
        " line when undoing a FormatBuffer call. See the linked post.
        function! FormatBuffer()
          let view = winsaveview()
          " https://vim.fandom.com/wiki/Restore_the_cursor_position_after_undoing_text_change_made_by_a_script
          normal ix
          normal x
          try | silent undojoin | catch | endtry
          keepjumps normal ggVGgq
          call winrestview(view)
        endfunction

        function! ReflowComment(type, ...)
            let l:fp = &formatprg
            set formatprg=

            if a:type ==? 'v'
                normal! '<v'>gq
            else
                normal! '[v']gq
            endif

            let &formatprg = l:fp
        endfunction

        augroup SetPath
          autocmd!
          autocmd BufEnter,DirChanged * call pathutils#SetPath()
        augroup END

        augroup highlight_yank
            autocmd!
            autocmd TextYankPost * silent! lua require'vim.highlight'.on_yank()
        augroup END

        let mapleader = " "
        let maplocalleader = ","

        imap     jk        <Esc>
        tnoremap <Esc>     <C-\><C-n>
        nnoremap <BS>      <C-^>
        nnoremap Y         y$

        nnoremap <leader>fw :grep -wF <cword><cr>
        nnoremap <leader>fs :grep 
        nnoremap <leader>ff :find 
        nnoremap <leader>fz :call fzf#run({'sink': 'e', 'tmux': '-p80%,60%', 'options': '--no-color'})<cr>
        nnoremap <leader>fb :ls<cr>:buffer<Space>

        map f <Plug>Sneak_f
        map F <Plug>Sneak_F
        map t <Plug>Sneak_t
        map T <Plug>Sneak_T

        nmap     <leader>rb :call FormatBuffer()<cr>
        nnoremap <leader>rc :set operatorfunc=ReflowComment<cr>g@
        vnoremap <leader>rc :<C-u>call ReflowComment(visualmode())<cr>

        nnoremap <leader>/ :nohlsearch<CR>

        nnoremap <leader>T :lcd %:p:h<bar>split term://fish<CR>
        nnoremap <leader>t :split term://fish<CR>

        map      <leader>C <Plug>(sad-change-backward)
        map      <leader>c <Plug>(sad-change-forward)

        vmap     <Enter>   <Plug>(EasyAlign)

        let g:sandwich_no_default_key_mappings = 1
        silent! nmap <unique><silent> <leader>sd <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> <leader>sr <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-query-a)
        silent! nmap <unique><silent> <leader>sD <Plug>(operator-sandwich-delete)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)
        silent! nmap <unique><silent> <leader>sR <Plug>(operator-sandwich-replace)<Plug>(operator-sandwich-release-count)<Plug>(textobj-sandwich-auto-a)

        let g:operator_sandwich_no_default_key_mappings = 1
        silent! nmap <unique> <leader>sa <Plug>(operator-sandwich-add)
        silent! xmap <unique> <leader>sa <Plug>(operator-sandwich-add)
        silent! omap <unique> <leader>sa <Plug>(operator-sandwich-g@)
        silent! xmap <unique> <leader>sd <Plug>(operator-sandwich-delete)
        silent! xmap <unique> <leader>sr <Plug>(operator-sandwich-replace)

        autocmd FileType xml setl fp=prettier\ --stdin-filepath\ %
        autocmd FileType sh setl fp=shfmt mp=shellcheck\ -f\ gcc\ % | nnoremap <buffer> <localleader>m :silent make<cr>
        autocmd FileType rust setl fp=rustfmt mp=cargo\ check
        autocmd FileType purescript setl fp=purty\ format | nnoremap <buffer> <localleader>t :!spago\ docs\ --format\ ctags
        autocmd FileType nix setl fp=nixpkgs-fmt
        autocmd FileType css setl fp=prettier\ --stdin-filepath\ %
        autocmd FileType dhall setl fp=dhall\ format
        autocmd FileType make setl noet
        autocmd FileType lua setl mp=luacheck\ --formatter\ plain
          \| nnoremap <localleader>m :make %<cr>
        autocmd FileType go setl fp=gofmt makeprg=go\ build\ -o\ /dev/null
          \| nnoremap <localleader>m :make %<cr>
          \| nnoremap <localleader>i :!goimports -w %<cr>
          \| nnoremap <localleader>t :execute ':silent !for f in ./{cmd, internal, pkg}; if test -d $f; ctags -R $f; end; end'<CR>
        autocmd FileType haskell setl fp=ormolu | nnoremap <buffer> <localleader>t :silent\ !fast-tags\ -R\ .
        autocmd FileType markdown setl fp=prettier\ --stdin-filepath\ %
        autocmd FileType json setl fp=prettier\ --stdin-filepath\ %
        autocmd FileType javascript setl fp=prettier\ --stdin-filepath\ % wig+=*node_modules*
        autocmd FileType typescript setl fp=prettier\ --stdin-filepath\ % wig+=*node_modules*
          \efm=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%# makeprg=${pkgs.nodePackages.eslint}/bin/eslint\ --format\ compact
          \| nnoremap <buffer> <silent> <localleader>f :!${pkgs.nodePackages.eslint}/bin/eslint\ --fix\ %<cr>
        autocmd FileType yaml setl fp=prettier\ --stdin-filepath\ %
        autocmd FileType clojure setl efm=%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m mp=clj-kondo\ --lint\ % wig+=*.clj-kondo*
      '';

      plugins = with pkgs.vimPlugins; with (import ../neovim/thirdparty.nix args); [
        editorconfig-vim
        vim-commentary
        vim-easy-align
        vim-dirvish
        vim-unimpaired
        vim-repeat
        fzfWrapper
        vim-gutentags
        vim-sandwich
        vim-sneak
        sad
        unicode-vim
        (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          name = "visual-split.vim";
          src = sources."visual-split.vim";
        })
        (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
          name = "neovim-set-path";
          src = sources."neovim-set-path";
        })
        vim-peekaboo
        vim-fugitive
        yui
        iceberg-vim

        dhall-vim
        haskell-vim
        Jenkinsfile-vim-syntax
        purescript-vim
        vim-js
        vim-jsx-pretty
        vim-lua
        vim-nix
        vim-terraform
      ];
    };
  };
}

