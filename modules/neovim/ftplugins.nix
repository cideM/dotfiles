{ config, lib, pkgs, ... }:

{
  "nvim/ftplugin/xml.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      let &formatprg='${pkgs.nodePackages.prettier}/bin/prettier' . ' --stdin-filepath ' . expand('%')
      let b:undo_ftplugin .= '|setlocal formatprg<'
    '';
  };
  "nvim/ftplugin/vim.vim" = {
    text = ''
      setlocal foldmethod=indent
    '';
  };
  "nvim/ftplugin/sh.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      setlocal foldmethod=indent
      let b:undo_ftplugin .= '|setlocal foldmethod<'

      setlocal makeprg=${pkgs.shellcheck}/bin/shellcheck\ -f\ gcc\ %
      let b:undo_ftplugin .= '|setlocal makeprg<'

      setlocal formatprg=shfmt
      let b:undo_ftplugin .= '|setlocal formatprg<'

      nnoremap <buffer> <localleader>m :silent make<CR>
    '';
  };
  "nvim/ftplugin/rust.vim" = {
    text = ''
      let b:undo_ftplugin="setlocal makeprg< formatprg<"

      setlocal makeprg=${pkgs.cargo}/bin/cargo\ check 
      setlocal formatprg=rustfmt
    '';
  };
  "nvim/ftplugin/purescript.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      setlocal formatprg='${pkgs.nodePackages.purty}/bin/purty' -
      let b:undo_ftplugin .= '|setlocal formatprg<'

      command! -buffer SpagoTags :execute '!spago docs --format ctags'
    '';
  };
  "nvim/ftplugin/nix.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      setlocal formatprg=${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt
      let b:undo_ftplugin .= '|setlocal formatprg<'

      setlocal foldmethod=indent
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/markdown.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      let &formatprg='${pkgs.nodePackages.prettier}/bin/prettier' . ' --stdin-filepath ' . expand('%')
      let b:undo_ftplugin .= '|setlocal formatprg<'
    '';
  };
  "nvim/ftplugin/make.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      setlocal shiftwidth=4
      let b:undo_ftplugin .= '|setlocal shiftwidth<'

      setlocal tabstop=4
      let b:undo_ftplugin .= '|setlocal tabstop<'

      setlocal noexpandtab
      let b:undo_ftplugin .= '|setlocal noexpandtab<'

      setlocal shiftwidth=4
      let b:undo_ftplugin .= '|setlocal shiftwidth<'

      nnoremap <buffer> <localleader>r :%retab!<cr>
    '';
  };
  "nvim/ftplugin/lua.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      setlocal makeprg=${pkgs.lua53Packages.luacheck}/bin/luacheck\ --formatter\ plain
      let b:undo_ftplugin .= '|setlocal makeprg<'

      setlocal foldmethod=syntax
      let b:undo_ftplugin .= '|setlocal foldmethod<'

      nnoremap <buffer> <silent> <localleader>m :make %<cr>
    '';
  };
  "nvim/ftplugin/json.vim" = {
    text = ''
      let b:undo_ftplugin="setlocal formatprg< foldmethod<"

      setlocal foldmethod=indent

      let &formatprg='${pkgs.nodePackages.prettier}/bin/prettier' . ' --stdin-filepath ' . expand('%')
      let b:undo_ftplugin .= '|setlocal formatprg<'

      setlocal foldmethod=expr
      setlocal foldexpr=nvim_treesitter#foldexpr()
      let b:undo_ftplugin .= '|setlocal foldexpr<'
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/javascript.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      let &formatprg='${pkgs.nodePackages.prettier}/bin/prettier' . ' --stdin-filepath ' . expand('%')
      let b:undo_ftplugin .= '|setlocal formatprg<'

      let &makeprg='${pkgs.nodePackages.eslint}/bin/eslint' . ' --format compact '
      setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
      let b:undo_ftplugin .= '|setlocal makeprg<'
      command! -bar -buffer Fix call system(eslint_path . ' --fix ' . expand('%')) | edit
      nnoremap <buffer> <silent> <localleader>f :Fix<cr>

      let g:jsx_ext_required        = 0
      let b:undo_ftplugin .= '|unlet g:jsx_ext_required'

      let g:javascript_plugin_jsdoc = 1
      let b:undo_ftplugin .= '|unlet g:javascript_plugin_jsdoc'

      let g:javascript_plugin_flow  = 1
      let b:undo_ftplugin .= '|unlet g:javascript_plugin_flow'

      setlocal wildignore+=*/node_modules/*
      let b:undo_ftplugin .= '|setlocal wildignore<'


      setlocal suffixesadd+=.js,.jsx,.css
      let b:undo_ftplugin .= '|setlocal suffixesadd<'

      nnoremap <buffer> <silent> <localleader>m :make %<cr>

      command! -bar -buffer JestSplit :split | execute 'terminal jest '. expand('%')
      nnoremap <buffer> <silent> <localleader>ts :JestSplit<cr>

      command! -bar -buffer JestSplitWatch :split | execute 'terminal jest --watch '. expand('%')
      nnoremap <buffer> <silent> <localleader>tw :JestSplitWatch<cr>

      setlocal foldmethod=expr
      setlocal foldexpr=nvim_treesitter#foldexpr()
      let b:undo_ftplugin .= '|setlocal foldexpr<'
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/dhall.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      set iskeyword+=.
      let b:undo_ftplugin .= '|setlocal iskeyword<'

      setlocal formatprg=${pkgs.dhall}/bin/dhall\ format
      let b:undo_ftplugin .= '|setlocal formatprg<'

      nnoremap <buffer> <localleader>m :make %<cr>
    '';
  };
  "nvim/ftplugin/css.vim" = {
    text = ''
      set suffixesadd+=.js,.jsx,.css

      let &formatprg='${pkgs.nodePackages.prettier}/bin/prettier' . ' --stdin-filepath ' . expand('%')
      let b:undo_ftplugin .= '|setlocal formatprg<'
    '';
  };
  "nvim/ftplugin/go.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      compiler go

      setlocal formatprg=gofmt
      let b:undo_ftplugin .= '|setlocal formatprg<'

      setlocal makeprg=go\ build\ -o\ /dev/null
      let b:undo_ftplugin .= '|setlocal makeprg<'

      " https://github.com/leeren/dotfiles/blob/master/vim/.vim/ftplugin/go.vim
      command! -buffer -range=% Gofmt let b:winview = winsaveview() |
        \ silent! execute <line1> . "," . <line2> . "!gofmt " | 
        \ call winrestview(b:winview)

      command! -buffer -range=% Goimport let b:winview = winsaveview() |
        \ silent! execute <line1> . "," . <line2> . "!goimports " | 
        \ call winrestview(b:winview)

      nnoremap <silent> <localleader>m :execute 'make ' . expand('%:p:h')<CR>
      nnoremap <silent> <localleader>i :Goimport<CR>

      setlocal foldmethod=expr
      setlocal foldexpr=nvim_treesitter#foldexpr()
      let b:undo_ftplugin .= '|setlocal foldexpr<'
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/typescript.vim" = {
    text = ''
        let b:undo_ftplugin = ""

        let node_modules = luaeval(
                    \'require("findUp").findUp(unpack(_A))', 
                    \['node_modules',expand('%:p:h'), '/']
                    \)

        let &formatprg='${pkgs.nodePackages.prettier}/bin/prettier' . ' --stdin-filepath ' . expand('%')
        let b:undo_ftplugin .= '|setlocal formatprg<'

        """""""""""""""""""""""""
      "        TSLINT         "
      """""""""""""""""""""""""
        let tslint_path = ""

        if node_modules !=# "false" && filereadable(node_modules . "/.bin/tslint")
            let tslint_path = node_modules . "/.bin/tslint"
        elseif executable("tslint")
            let tslint_path = "tslint"
        end

        if tslint_path !=# ""
            let &makeprg=tslint_path . ' --format compact '
            setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
            let b:undo_ftplugin .= '|setlocal makeprg<'

            command! -bar -buffer Fix call system(tslint_path . ' --fix ' . expand('%')) | edit
            nnoremap <buffer> <silent> <localleader>f :Fix<cr>
        end

        set wildignore+=*/node_modules/*
        let b:undo_ftplugin .= '|setlocal wildignore<'

        setlocal suffixesadd+=.ts,.tsx,.css
        let b:undo_ftplugin .= '|setlocal suffixesadd<'

        setlocal foldmethod=expr
        setlocal foldexpr=nvim_treesitter#foldexpr()
        let b:undo_ftplugin .= '|setlocal foldexpr<'
        let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/python.vim" = {
    text = ''
      let b:undo_ftplugin = ""
      setlocal foldmethod=expr
      setlocal foldexpr=nvim_treesitter#foldexpr()
      let b:undo_ftplugin .= '|setlocal foldexpr<'
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/haskell.vim" = {
    text = ''
      let b:undo_ftplugin="setlocal formatprg< foldmethod<"

      set foldmethod=indent

      set formatprg=${pkgs.ormolu}/bin/ormolu

      nnoremap <buffer> <localleader>t :silent !fast-tags -R .<cr>
      setlocal foldmethod=expr
      setlocal foldexpr=nvim_treesitter#foldexpr()
      let b:undo_ftplugin .= '|setlocal foldexpr<'
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/clojure.vim" = {
    text = ''
      let b:undo_ftplugin = ""
      setlocal wildignore+=*/.clj-kondo/*

      packadd parinfer-rust

      " I think auto closing pairs and parinfer won't get along
      let b:lexima_disabled = 1

      let current_compiler="clj-kondo"

      " https://github.com/borkdude/clj-kondo/blob/master/doc/editor-integration.md#vanilla-way
      setlocal errorformat=%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m
      setlocal makeprg=clj-kondo\ --lint\ %

      setlocal foldmethod=expr
      setlocal foldexpr=nvim_treesitter#foldexpr()
      let b:undo_ftplugin .= '|setlocal foldexpr<'
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/yaml.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      let &formatprg='${pkgs.nodePackages.prettier}/bin/prettier' . ' --stdin-filepath ' . expand('%')
      let b:undo_ftplugin .= '|setlocal formatprg<'
      setlocal foldmethod=expr
      setlocal foldexpr=nvim_treesitter#foldexpr()
      let b:undo_ftplugin .= '|setlocal foldexpr<'
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
}
