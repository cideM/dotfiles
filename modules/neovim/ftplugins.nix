{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.neovim;

  useAle = cfg.clojure.kondo.enable || cfg.ale.enable || cfg.haskell.hlint.enable;

in
{
  "nvim/ftplugin/xml.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      let node_modules = luaeval(
                  \'require("findUp").findUp(unpack(_A))', 
                  \['node_modules',expand('%:p:h'), '/']
                  \)

      """""""""""""""""""""""""
      "      PRETTIER         "
      """""""""""""""""""""""""
      let prettier_path = ""

      if node_modules !=# "false" && filereadable(node_modules . "/.bin/prettier")
          let prettier_path = node_modules . "/.bin/prettier"
      elseif executable("prettier")
          let prettier_path = "prettier"
      end

      if prettier_path !=# ""
          let &formatprg=prettier_path . ' --stdin-filepath ' . expand('%')
          let b:undo_ftplugin .= '|setlocal formatprg<'
      end
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

      setlocal makeprg=shellcheck\ -f\ gcc\ %
      let b:undo_ftplugin .= '|setlocal makeprg<'

      setlocal formatprg=shfmt
      let b:undo_ftplugin .= '|setlocal formatprg<'

      nnoremap <buffer> <localleader>m :silent make<CR>
    '';
  };
  "nvim/ftplugin/rust.vim" = {
    text = ''
      let b:undo_ftplugin="setlocal makeprg< formatprg<"

      setlocal makeprg=cargo\ check 
      setlocal formatprg=rustfmt
    '';
  };
  "nvim/ftplugin/purescript.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      setlocal formatprg=purty\ -
      let b:undo_ftplugin .= '|setlocal formatprg<'

      command! -buffer SpagoTags :execute '!spago docs --format ctags'
    '';
  };
  "nvim/ftplugin/nix.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      setlocal formatprg=nixpkgs-fmt
      let b:undo_ftplugin .= '|setlocal formatprg<'

      setlocal foldmethod=indent
      let b:undo_ftplugin .= '|setlocal foldmethod<'
    '';
  };
  "nvim/ftplugin/markdown.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      let &l:formatprg = 'prettier --parser markdown --stdin-filepath %'
      let b:undo_ftplugin .= '|unlet formatprg<'
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

      setlocal
      makeprg=luacheck\ --formatter\ plain
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

      let &l:formatprg = 'prettier --stdin-filepath %'
    '';
  };
  "nvim/ftplugin/javascript.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      let node_modules = luaeval(
      \'require("findUp").findUp(unpack(_A))',
      \['node_modules',expand('%:p:h'), '/']
      \)

      ${if useAle then ''
        let b:ale_linters = ['eslint']
        packadd ale
      '' else ""}

      """""""""""""""""""""""""
        "      PRETTIER         "
        """""""""""""""""""""""""
      let prettier_path = ""

      if node_modules !=# "false" && filereadable(node_modules . "/.bin/prettier")
      let prettier_path = node_modules . "/.bin/prettier"
      elseif executable("prettier")
      let prettier_path = "prettier"
      end

      if prettier_path !=# ""
      let &formatprg=prettier_path . ' --stdin-filepath ' . expand('%')
      let b:undo_ftplugin .= '|setlocal formatprg<'
      end

      """""""""""""""""""""""""
        "        ESLINT         "
        """""""""""""""""""""""""
      let eslint_path = ""

      if node_modules !=# "false" && filereadable(node_modules . "/.bin/eslint")
      let eslint_path = node_modules . "/.bin/eslint"
      elseif executable("eslint")
      let eslint_path = "eslint"
      end

      if eslint_path !=# ""
      let &makeprg=eslint_path . ' --format compact '
      setlocal errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#
      let b:undo_ftplugin .= '|setlocal makeprg<'

      command! -bar -buffer Fix call system(eslint_path . ' --fix ' . expand('%')) | edit
      nnoremap <buffer> <silent> <localleader>f :Fix<cr>
      end

      let g:jsx_ext_required        = 0
      let b:undo_ftplugin .= '|unlet g:jsx_ext_required'

      let g:javascript_plugin_jsdoc = 1
      let b:undo_ftplugin .= '|unlet g:javascript_plugin_jsdoc'

      let g:javascript_plugin_flow  = 1
      let b:undo_ftplugin .= '|unlet g:javascript_plugin_flow'

      setlocal wildignore+=*/node_modules/*
      let b:undo_ftplugin .= '|setlocal wildignore<'

      setlocal foldmethod=syntax
      let b:undo_ftplugin .= '|setlocal foldmethod<'

      setlocal suffixesadd+=.js,.jsx,.css
      let b:undo_ftplugin .= '|setlocal suffixesadd<'

      nnoremap <buffer> <silent> <localleader>m :make %<cr>

      command! -bar -buffer JestSplit :split | execute 'terminal jest '. expand('%')
      nnoremap <buffer> <silent> <localleader>ts :JestSplit<cr>

      command! -bar -buffer JestSplitWatch :split | execute 'terminal jest --watch '. expand('%')
      nnoremap <buffer> <silent> <localleader>tw :JestSplitWatch<cr>
    '';
  };
  "nvim/ftplugin/dhall.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      set iskeyword+=.
      let b:undo_ftplugin .= '|setlocal iskeyword<'

      setlocal formatprg=dhall\ format
      let b:undo_ftplugin .= '|setlocal formatprg<'

      nnoremap <buffer> <localleader>m :make %<cr>
    '';
  };
  "nvim/ftplugin/css.vim" = {
    text = ''
      set suffixesadd+=.js,.jsx,.css

      let node_modules = luaeval(
      \'require("findUp").findUp(unpack(_A))',
      \['node_modules',expand('%:p:h'), '/']
      \)

      """""""""""""""""""""""""
        "      PRETTIER         "
        """""""""""""""""""""""""
      let prettier_path = ""

      if node_modules !=# "false" && filereadable(node_modules . "/.bin/prettier")
      let prettier_path = node_modules . "/.bin/prettier"
      elseif executable("prettier")
      let prettier_path = "prettier"
      end

      if prettier_path !=# ""
      let &formatprg=prettier_path . ' --stdin-filepath ' . expand('%')
      let b:undo_ftplugin .= '|setlocal formatprg<'
      end
    '';
  };
  "nvim/ftplugin/go.vim" = {
    text = ''
      let b:undo_ftplugin = ""

      ${if useAle then ''
        let b:ale_linters = ['gopls', 'gosimple', 'go vet']
        packadd ale
      '' else ""}

      compiler go

      ${if cfg.treesitter.enable then ''
        setlocal foldmethod=expr
        setlocal foldexpr=nvim_treesitter#foldexpr()
        let b:undo_ftplugin .= '|setlocal foldexpr<'
      '' else ''
        setlocal foldmethod=syntax
      ''}
      let b:undo_ftplugin .= '|setlocal foldmethod<'

      setlocal formatprg=gofmt
      let b:undo_ftplugin .= '|setlocal formatprg<'

      " https://github.com/leeren/dotfiles/blob/master/vim/.vim/ftplugin/go.vim
        command! -buffer -range=% Gofmt let b:winview = winsaveview() |
          \ silent! execute <line1> . "," . <line2> . "!gofmt " | 
          \ call winrestview(b:winview)

        command! -buffer -range=% Goimport let b:winview = winsaveview() |
          \ silent! execute <line1> . "," . <line2> . "!goimports " | 
          \ call winrestview(b:winview)

        nnoremap <silent> <localleader>mc :execute 'make ' . expand('%:p:h')<CR>
        nnoremap <silent> <localleader>mm :make ./...<CR>
        nnoremap <silent> <localleader>i :Goimport<CR>
        nnoremap <silent> <localleader>ma :call goutils#MakeprgAsyncProject()<CR>
        nnoremap <silent> <localleader>tw :call goutils#RunTestAtCursor()<CR>
        nnoremap <silent> <localleader>ta :call goutils#RunAllTests()<CR>
    '';
  };
  "nvim/ftplugin/typescript.vim" = {
    text = ''
        let b:undo_ftplugin = ""

        let node_modules = luaeval(
                    \'require("findUp").findUp(unpack(_A))', 
                    \['node_modules',expand('%:p:h'), '/']
                    \)

        """""""""""""""""""""""""
      "      PRETTIER         "
      """""""""""""""""""""""""
        let prettier_path = ""

        if node_modules !=# "false" && filereadable(node_modules . "/.bin/prettier")
            let prettier_path = node_modules . "/.bin/prettier"
        elseif executable("prettier")
            let prettier_path = "prettier"
        end

        if prettier_path !=# ""
            let &formatprg=prettier_path . ' --stdin-filepath ' . expand('%')
            let b:undo_ftplugin .= '|setlocal formatprg<'
        end

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

        ${if cfg.treesitter.enable then ''
          setlocal foldmethod=expr
          setlocal foldexpr=nvim_treesitter#foldexpr()
          let b:undo_ftplugin .= '|setlocal foldexpr<'
          '' else ''
          setlocal foldmethod=syntax
        ''}

    '';
  };
  "nvim/ftplugin/haskell.vim" = {
    text = ''
      let b:undo_ftplugin="setlocal formatprg< foldmethod<"

      set foldmethod=indent

      set formatprg=ormolu

      ${if useAle then ''
      let b:ale_linters = ['hlint']
      packadd ale
      '' else ""}

      nnoremap <buffer> <localleader>t :silent !fast-tags -R .<cr>
    '';
  };
  "nvim/ftplugin/clojure.vim" = {
    text = ''
        " TODO: Port to Nix
      if exists("current_compiler")
      finish
      endif
      let current_compiler="clj-kondo"

      ${if cfg.clojure.enable then ''
        packadd conjure
      '' else ""}

      ${if useAle then ''
          let b:ale_linters = ['clj-kondo']
          packadd ale
        '' else ""}

      ${if cfg.completion.enable && cfg.completion.backend == "completion-nvim" then ''
          let b:no_completion_nvim=1
          packadd deoplete-nvim
          packadd deoplete-lsp
          call deoplete#enable()
          autocmd! deoplete#lsp
          call deoplete#custom#option('num_processes', 2)
          " I recommend for you to disable deoplete-options-refresh_always option
          " when you enable deoplete parallel completion.
          call deoplete#custom#option('refresh_always', v:false)
        '' else ""}

      if exists(":CompilerSet") != 2
      command -nargs=* CompilerSet setlocal <args>
      endif

      " https://github.com/borkdude/clj-kondo/blob/master/doc/editor-integration.md#vanilla-way
        CompilerSet errorformat=%f:%l:%c:\ Parse\ %t%*[^:]:\ %m,%f:%l:%c:\ %t%*[^:]:\ %m
        CompilerSet makeprg=clj-kondo\ --lint\ %
    '';
  };
  "nvim/ftplugin/yaml.vim" = {
    text = ''
        let b:undo_ftplugin = ""

        ${if cfg.treesitter.enable then ''
          setlocal foldmethod=expr
          setlocal foldexpr=nvim_treesitter#foldexpr()
          let b:undo_ftplugin .= '|setlocal foldexpr<'
          '' else ''
          setlocal foldmethod=indent
        ''}

        let node_modules = luaeval(
                    \'require("findUp").findUp(unpack(_A))', 
                    \['node_modules',expand('%:p:h'), '/']
                    \)

        """""""""""""""""""""""""
      "      PRETTIER         "
      """""""""""""""""""""""""
        let prettier_path = ""

        if node_modules !=# "false" && filereadable(node_modules . "/.bin/prettier")
            let prettier_path = node_modules . "/.bin/prettier"
        elseif executable("prettier")
            let prettier_path = "prettier"
        end

        if prettier_path !=# ""
            let &formatprg=prettier_path . ' --stdin-filepath ' . expand('%')
            let b:undo_ftplugin .= '|setlocal formatprg<'
        end
    '';
  };
}
