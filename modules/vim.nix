args @ {
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with types; let
  makeIndentPlugins = ftplugins:
    with attrsets;
      mapAttrs'
      (key: value: nameValuePair ".vim/after/indent/${key}.vim" {text = value;})
      ftplugins;

  makeFtPlugins = ftplugins:
    with attrsets;
      mapAttrs'
      (key: value: nameValuePair ".vim/after/ftplugin/${key}.vim" {text = value;})
      ftplugins;
in {
  config = {
    home.file =
      makeFtPlugins {
        go = ''
          compiler go
        '';
        typescript = ''
          set re=0
        '';
      }
      // makeIndentPlugins {
        html = ''
          set indentexpr=""
        '';
      }
      // {
        ".vim/after/plugin/sensible.vim" = {
          text = ''
            set listchars=eol:¬,space:\ ,lead:\ ,trail:·,nbsp:◇,tab:→\ ,extends:❯,precedes:❮,multispace:\·\ \ \,leadmultispace:\│\ \ \ ,
          '';
        };
      };
    programs.vim = {
      enable = true;
      extraConfig = ''
        unlet! skip_defaults_vim
        source $VIMRUNTIME/defaults.vim

        packadd! matchit

        set hlsearch
        set visualbell
        set textwidth=72
        set formatoptions+=r
        set modelines=1
        set background=light
        set number
        set hidden
        set cursorline
        set noerrorbells
        set noexpandtab
        set nostartofline
        set autoindent
        set termguicolors
        set backspace=2
        set laststatus=2
        set list
        set listchars=eol:¬,space:\ ,lead:\ ,trail:·,nbsp:◇,tab:→\ ,extends:❯,precedes:❮,multispace:\·\ \ \,leadmultispace:\│\ \ \ ,
        set grepprg=rg\ -H\ --vimgrep
        colorscheme catppuccin_latte

        let mapleader = " "
        nnoremap <BS> <C-^>
      '';
      plugins = with pkgs.vimPlugins; [vim-sensible editorconfig-vim catppuccin-vim];
    };
  };
}
