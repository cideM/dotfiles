# Plugins I might want to check out
# - https://github.com/akinsho/nvim-toggleterm.lua

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

      package = pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "master";
        src = config.sources.neovim;
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.tree-sitter ];
      });

      extraConfig = (import ./initvim.nix args);

      plugins = with pkgs.vimPlugins; with (import ./thirdparty.nix args); [
        editorconfig-vim
        targets-vim
        vim-commentary
        vim-easy-align
        vim-eunuch
        vim-peekaboo
        vim-indent-object
        vim-matchup
        vim-cool
        vim-sayonara
        vim-repeat
        vim-sandwich
        # v-- Pretty slow
        vim-unimpaired
        vim-dirvish
        vim-scriptease
        # v-- doesn't work with treesitter
        # inspecthi
        # neovim-set-path
        nvim-lspconfig
        sad
        vim-sneak
        fzf-vim
        qfenter
        suda.vim
        unicode-vim
        nvim-compe

        # Git
        vim-fugitive
        vim-rhubarb
        git-messenger-vim

        # Language Tooling
        vim-markdown-folding
        conjure-compe
        conjure
        parinfer-rust

        # Languages & Syntax
        purescript-vim
        vim-nix
        dhall-vim
        vim-js
        vim-lua
        vim-jsx-pretty
        Jenkinsfile-vim-syntax
        haskell-vim
        vim-terraform

        # Themes
        apprentice
        vim-colors-github
        yui
        seoul256-vim
        iceberg-vim
        vim-one
        onehalf
        papercolor-theme
        falcon
        vim-kuroi-colors
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

        {
          plugin = nvim-treesitter;
          optional = true;
        }

        {
          plugin = parinfer-rust;
          optional = true;
        }

        {
          plugin = nvim-lsp;
          optional = true;
        }
      ];
    };
  };
}
