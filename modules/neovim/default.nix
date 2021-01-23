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
    home.packages = mkIf (pkgs.stdenv.isDarwin == false) [ clj-kondo ];

    xdg.configFile = (import ./ftplugins.nix args);

    programs.neovim = {

      enable = true;

      package = pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "master";
        src = config.sources.neovim;
        buildInputs = oldAttrs.buildInputs ++ [ pkgs.tree-sitter ];
      });

      configure = with pkgs.vimPlugins; with (import ./thirdparty.nix args); {
        customRC = (import ./initvim.nix args);

        packages = {
          foobar = {
            start = [

              editorconfig-vim
              targets-vim
              vim-colortemplate
              vim-commentary
              vim-easy-align
              vim-eunuch
              vim-gutentags
              vim-indent-object
              vim-matchup
              vim-peekaboo
              vim-repeat
              vim-sandwich
              # Pretty slow
              vim-unimpaired
              vim-dirvish
              vim-scriptease
              inspecthi
              neovim-set-path
              nvim-lspconfig
              sad
              vim-sneak
              # chadtree

              # Git
              vim-fugitive
              vim-rhubarb

              # Language Tooling
              vim-markdown-folding
              conjure
              vim-parinfer

              # Languages & Syntax
              purescript-vim
              vim-nix
              dhall-vim
              vim-js
              vim-lua
              yats-vim
              vim-jsx-pretty
              Jenkinsfile-vim-syntax
              haskell-vim
              vim-terraform
              fennel-vim

              # Themes
              apprentice
              vim-colors-github
              yui
              seoul256-vim
              iceberg-vim
              vim-one
              onehalf
              papercolor-theme
              onedark-vim
              jellybeans-vim
              falcon
              vim-kuroi-colors
              vim-nightowl-colors
              vim-tokyonight-colors
              spacevim

              # Treesitter
              grammarClojure
              # Doesn't build
              grammarNix
              grammarJavascript
              grammarPython
              grammarHaskell
              grammarJson
              grammarGo
              grammarYaml
              grammarTs
              grammarTsx

            ]
            ++ (builtins.map
              (pkg: pkgs.vimUtils.buildVimPluginFrom2Nix {
                pname = pkg;
                version = "latest";
                src = ./. + "/plugins" + ("/" + pkg);
              })
              [
                "find-utils"
                "reflow"
                "zen"
              ]);

            opt = [
              nvim-treesitter
              nvim-lsp
            ];
          };
        };
      };
    };
  };
}
