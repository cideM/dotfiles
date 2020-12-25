{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.programs.neovim;

  ftPluginDir = toString ./ftplugin;

  # For ./. see https://github.com/NixOS/nix/issues/1074 otherwise it's not an
  # absolute path
  readFtplugin = name: builtins.readFile ("${ftPluginDir}/${name}.vim");

  # TODO: Convert to Nix text
  ftPlugins =
    trivial.pipe
      [
        "css"
        "dhall"
        "haskell"
        "javascript"
        "Jenkinsfile"
        "json"
        "lua"
        "make"
        "purescript"
        "markdown"
        "rust"
        "sh"
        "nix"
        "vim"
        "xml"
      ]
      [ (builtins.map (name: attrsets.nameValuePair name (readFtplugin name))) (builtins.listToAttrs) ];

  ftPluginsAttrs = attrsets.mapAttrs'
    (ft: vimscript:
      attrsets.nameValuePair ("nvim/ftplugin/${ft}.vim") ({
        text = ''
          " Generated by my Nix neovim module, all edits will be lost if not
          " made in the Nix source
        '' + vimscript;
      })
    )
    ftPlugins;
in
ftPluginsAttrs // {
  "nvim/ftplugin/go.vim" = {
    text = ''
      let b:undo_ftplugin = ""

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

      ${if cfg.haskell.hlint.enable then ''
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

      ${if cfg.clojure.kondo.enable then ''
        let b:ale_linters = ['clj-kondo']
        packadd ale
      '' else ""}

      ${if cfg.completion.enable then ''
        let b:no_completion_nvim=1
        packadd deoplete-nvim
        packadd deoplete-lsp
        call deoplete#enable()
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
