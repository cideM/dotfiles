{ config, lib, pkgs, ... }:

with lib;
with types;
let
  luaLsp = builtins.readFile ./lsp.lua;

  treesitter = builtins.readFile ./treesitter.lua;

  init = builtins.readFile ./init.vim;

  ftPluginDir = toString ./ftplugin;

  # For ./. see https://github.com/NixOS/nix/issues/1074 otherwise it's not an
  # absolute path
  readFtplugin = name: builtins.readFile ("${ftPluginDir}/${name}.vim");

  plugins = (import ./plugins.nix { inherit pkgs; });

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
      ftPluginsAttrs // {
        "nvim/lsp.lua".text = luaLsp;
        "nvim/treesitter.lua".text = treesitter;
      }
    );

    programs.neovim = {
      enable = true;

      package = pkgs.neovim-unwrapped.overrideAttrs (oldAttrs: rec {
        version = "master";
        src = (import ./nix/sources.nix).neovim;
      });

      configure = {
        customRC = init;

        packages.foobar = {
          start = [
            pkgs.vimPlugins.editorconfig-vim
            pkgs.vimPlugins.targets-vim
            pkgs.vimPlugins.vim-commentary
            pkgs.vimPlugins.vim-dirvish
            pkgs.vimPlugins.vim-easy-align
            pkgs.vimPlugins.vim-eunuch
            pkgs.vimPlugins.vim-gutentags
            pkgs.vimPlugins.vim-indent-object
            pkgs.vimPlugins.vim-repeat
            pkgs.vimPlugins.vim-sandwich
            pkgs.vimPlugins.vim-sneak
            pkgs.vimPlugins.vim-unimpaired
            pkgs.vimPlugins.vim-peekaboo
            pkgs.vimPlugins.vim-mundo
            plugins.sad
            plugins.vim-colortemplate
            plugins.vim-cool
            plugins.vim-visual-split
            plugins.vim-matchup
            plugins.vim-qf
            plugins.nvim-colorizer

            # Git
            pkgs.vimPlugins.vim-fugitive
            pkgs.vimPlugins.gv-vim
            pkgs.vimPlugins.vim-rhubarb
            pkgs.vimPlugins.vim-gist

            # Language Tooling
            plugins.parinfer-rust
            plugins.vim-markdown-folding
            plugins.conjure

            # Themes
            plugins.apprentice
            plugins.yui
            plugins.spacevim
            plugins.vim-one-theme
            plugins.onehalf
            pkgs.vimPlugins.iceberg-vim

            # Languages & Syntax
            pkgs.vimPlugins.purescript-vim
            pkgs.vimPlugins.vim-nix
            pkgs.vimPlugins.dhall-vim
            plugins.vim-js
            plugins.vim-lua
            pkgs.vimPlugins.yats-vim
            pkgs.vimPlugins.vim-jsx-pretty
            pkgs.vimPlugins.Jenkinsfile-vim-syntax

            ## Treesitter
            plugins.treesitterGo
            plugins.treesitterYaml

          ]
          ++ localPlugins;

          opt = [
            plugins.nvim-treesitter
            plugins.nvim-lsp
          ];
        };
      };

    };
  };
}
