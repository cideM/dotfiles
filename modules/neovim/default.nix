args@{ config, lib, pkgs, ... }:

with lib;
with types;
let

  cfg = config.programs.neovim;

in
{
  config = {
    # It's broken on Darwin so there it needs to be installed with homebrew
    home.packages = mkIf (pkgs.stdenv.isDarwin == false) [ pkgs.clj-kondo ];

    xdg.configFile = (import ./ftplugins.nix args);

    programs.neovim = {

      enable = true;

      package = pkgs.neovim-unwrapped;

      extraConfig = (import ./initvim.nix args);

      plugins = with pkgs.vimPlugins; with (import ./thirdparty.nix args); [
        nvim-treesitter
        editorconfig-vim
        targets-vim
        vim-commentary
        vim-easy-align
        vim-eunuch
        vim-peekaboo
        vim-indent-object
        vim-matchup
        sad
        vim-grepper
        vim-cool
        vim-sayonara
        vim-repeat
        vim-sandwich
        vim-gutentags
        nvim-web-devicons
        # v-- Pretty slow
        vim-unimpaired
        vim-dirvish
        vim-scriptease
        # v-- doesn't work with treesitter
        # inspecthi
        # neovim-set-path
        nvim-lspconfig
        vim-sneak
        feline
        fzf-vim
        fzfWrapper
        qfenter
        suda-vim
        vimtex
        plenary-nvim
        unicode-vim
        /* compe-conjure */
        vim_current_word
        conjure
        # nvim-cursorline
        /* also seems to mess up fzf buffer highlighting */
        /* https://github.com/yamatsum/nvim-cursorline/issues/7 */
        /* nvim-compe */
        nvim-toggleterm-lua
        indent-blankline-nvim
        fern-vim
        lsp-status-nvim
        nvim-autopairs
        nvim-hlslens
        nvim-lspfuzzy

        # Git
        diffview
        vim-fugitive
        vim-flog
        vim-rhubarb
        git-messenger-vim
        conflict-marker
        gitsigns-nvim
        committia-vim

        # Language Tooling
        vim-markdown-folding
        parinfer-rust

        # Languages & Syntax
        dhall-vim
        haskell-vim
        Jenkinsfile-vim-syntax
        purescript-vim
        vim-js
        vim-jsx-pretty
        vim-lua
        vim-nix
        vim-terraform

        # Themes
        apprentice
        vim-colors-github
        yui
        iceberg-vim
        onehalf
        vim-nightowl-colors
        vim-tokyonight-colors
        spacevim

        # Treesitter
        grammarClojure
        grammarNix
        grammarJavascript
        grammarPython
        grammarHaskell
        grammarJson
        grammarGo
        grammarYaml
        grammarTs
        grammarTsx

        deoplete-lsp
        {
          plugin = deoplete-nvim;
          optional = true;
        }

        {
          plugin = parinfer-rust;
          optional = true;
        }

        {
          plugin = nvim-lspconfig;
          optional = true;
        }
      ];
    };
  };
}
