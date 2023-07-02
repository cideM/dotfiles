args @ {
  config,
  pkgs,
  ...
}: {
  config = {
    home.file = {
      ".vim/after/ftplugin/go.vim".text = "compiler go";
      ".vim/after/ftplugin/nix.vim".text = "setl kp=\"\"";
      ".vim/after/ftplugin/html.vim".text = ''
        setlocal keywordprg=open\ https://developer.mozilla.org/search?topic=api\\&topic=html\\&q=\
      '';
      ".vim/after/ftplugin/css.vim".text = ''
        setlocal keywordprg=open\ https://developer.mozilla.org/search?topic=api\\&topic=css\\&q=\
      '';
      ".vim/after/indent/html.vim".text = "set indentexpr=\"\"";
      ".vim/after/ftplugin/typescript.vim".text = "set re=0";
      ".vim/after/plugin/sensible.vim".text = ''
        set listchars=eol:¬,space:\ ,lead:\ ,trail:·,nbsp:◇,tab:→\ ,extends:❯,precedes:❮,multispace:\·\ \ \,leadmultispace:\│\ \ \ ,
      '';
    };
    programs.vim = {
      packageConfigurable = pkgs.vim-full.override {
        darwinSupport = true;
        guiSupport = false;
        netbeansSupport = false;
        cscopeSupport = false;
        rubySupport = false;
        pythonSupport = false;
      };
      enable = true;
      extraConfig = ''
        unlet! skip_defaults_vim
        source $VIMRUNTIME/defaults.vim

        packadd! matchit

        function! SynGroup()
            let l:s = synID(line('.'), col('.'), 1)
            echo synIDattr(l:s, 'name') . ' -> ' . synIDattr(synIDtrans(l:s), 'name')
        endfun

        set hlsearch
        set visualbell
        set textwidth=80
        set colorcolumn=+0
        set foldmethod=indent
        set formatoptions+=r
        set modelines=1
        set background=light
        set number
        set ignorecase
        set smartcase
        set hidden
        set noerrorbells
        set noexpandtab
        set nostartofline
        set autoindent
        set termguicolors
        set backspace=2
        set laststatus=2
        set list
        set grepprg=rg\ -H\ --vimgrep\ --smart-case
        colorscheme yui
        let g:yui_comments = 'emphasize'

        let mapleader = " "
        nnoremap <BS> <C-^>

        " Vim: also for text used to show unprintable characters in the text, 'listchars'.
        " Neovim: Text displayed differently from what it really is. But not 'listchars' whitespace.
        hi! link SpecialKey Whitespace
      '';
      plugins = with pkgs.vimPlugins; [vim-sensible editorconfig-vim yui];
    };
  };
}
