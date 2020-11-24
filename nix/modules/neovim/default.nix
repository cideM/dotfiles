{ config, lib, pkgs, ... }:

with lib;
with types;
let
  # Needed until https://github.com/NixOS/nixpkgs/pull/102763 lands in nixpkgs-unstable
  tree-sitter = pkgs.tree-sitter.overrideAttrs (oldAttrs: {
    version = "0.17.3";
    sha256 = "sha256-uQs80r9cPX8Q46irJYv2FfvuppwonSS5HVClFujaP+U=";
    cargoSha256 = "sha256-fonlxLNh9KyEwCj7G5vxa7cM/DlcHNFbQpp0SwVQ3j4=";

    postInstall = ''
      PREFIX=$out make install
    '';

    buildInputs = oldAttrs.buildInputs
      ++ pkgs.lib.optionals pkgs.stdenv.isDarwin [ pkgs.darwin.apple_sdk.frameworks.Security ];

    meta = oldAttrs.meta // { broken = false; };
  });

  init = builtins.readFile ./init.vim;

  ftPluginDir = toString ./ftplugin;

  # For ./. see https://github.com/NixOS/nix/issues/1074 otherwise it's not an
  # absolute path
  readFtplugin = name: builtins.readFile ("${ftPluginDir}/${name}.vim");

  plugins = (import ./plugins.nix { inherit pkgs; sources = config.sources; });

  # TODO: Should just add all automatically
  localPlugins =
    builtins.map
      (pkg: pkgs.vimUtils.buildVimPluginFrom2Nix {
        pname = pkg;
        version = "latest";
        src = ./. + "/plugins" + ("/" + pkg);
      })
      [
        "find-utils"
        "path-utils"
        "reflow"
        "syntax"
        "zen"
        "goutils"
      ];

  # TODO: Should just add all automatically
  ftPlugins =
    trivial.pipe
      [
        "css"
        "clojure"
        "dhall"
        "go"
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
        "typescript"
        "vim"
        "xml"
        "yaml"
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
{

  config = {
    xdg.configFile = (
      ftPluginsAttrs
    );

    programs.neovim = {
      enable = true;

      package = pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "master";
        src = config.sources.neovim;
        buildInputs = oldAttrs.buildInputs ++ [ tree-sitter ];
      });

      configure = with pkgs.vimPlugins; with plugins; {
        customRC = init;

        packages.foobar = {
          start = [

            editorconfig-vim
            limelight-vim
            sad
            targets-vim
            vim-asterisk
            vim-colortemplate
            vim-commentary
            vim-easy-align
            vim-eunuch
            vim-gutentags
            vim-indent-object
            vim-matchup
            vim-mundo
            vim-peekaboo
            vim-repeat
            vim-sandwich
            vim-scratch
            vim-sneak
            colorbuddy
            vim-unimpaired
            vim-visual-split
            vim-startify
            nvim-tree-lua
            vim-startuptime
            popup
            plenary
            vim-cool
            fern
            any-jump
            vim-dirvish
            vim-illuminate
            NrrwRgn

            # Completion
            completion-nvim
            completion-buffers
            completion-tags

            # Treesitter
            treesitterGo
            treesitterYaml
            treesitterTs
            treesitterTsx

            # Git
            vim-fugitive
            vim-gist
            vim-rhubarb
            committia
            vim-signify
            git-messenger-vim
            gv-vim
            gina

            # Language Tooling
            vim-markdown-folding
            parinfer-rust
            conjure
            vimtex

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

            # Themes
            apprentice
            yui
            spacevim
            onehalf
            iceberg-vim
            edge
            onebuddy
            sonokai
            highlite # This is technically both colors and also general

          ]
          ++ localPlugins;

          opt = [
            nvim-treesitter
            telescope
            nvim-lsp
            nvim-colorizer
          ];
        };
      };

    };
  };
}
