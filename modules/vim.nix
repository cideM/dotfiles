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

        let g:loaded_gzip = 1
        let g:loaded_zip = 1
        let g:loaded_zipPlugin = 1
        let g:loaded_tar = 1
        let g:loaded_tarPlugin = 1

        let g:loaded_getscript = 1
        let g:loaded_getscriptPlugin = 1
        let g:loaded_vimball = 1
        let g:loaded_vimballPlugin = 1
        let g:loaded_2html_plugin = 1

        let g:loaded_logiPat = 1
        let g:loaded_rrhelper = 1

        let g:loaded_netrw = 1
        let g:loaded_netrwPlugin = 1
        let g:loaded_netrwSettings = 1

        set hlsearch
        set visualbell
        set textwidth=80
        set colorcolumn=+0
        set foldmethod=indent
        set foldlevelstart=99
        set formatoptions+=r
        set modelines=1
        set background=light
        set number
        set ignorecase
        set smartcase
        set hidden
        set wildoptions=fuzzy,pum
        set noerrorbells
        set noexpandtab
        set nostartofline
        set autoindent
        set termguicolors
        set undodir=$HOME/.vim/undo
        set undofile
        set backspace=2
        set laststatus=2
        set list
        set grepprg=rg\ -H\ --vimgrep\ --smart-case
        let g:yui_comments = 'emphasize'
        colorscheme yui

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
