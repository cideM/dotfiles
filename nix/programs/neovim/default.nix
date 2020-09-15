{ pkgs, ... }:

{ lib, config, ... }:

with lib;
with builtins;
let
  # Figure out where to put this
  srcs = import ./nix/sources.nix;
  treesitterGo = pkgs.vimUtils.buildVimPluginFrom2Nix {
    version = "latest";
    name = "tree-sitter-go-${version}";
    src = srcs.treesitter-go;
    buildPhase = ''
      mkdir -p parser/
      cc -o parser/go.so -I./src -shared -Os -lstdc++ src/parser.c
    '';
    # installPhase = ''
    #   mkdir -p $out/parsers
    #   cp parser.so $out/parsers/
    # '';
  };

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

in
{
  config = {
    programs.neovim.enable = true;

    # TODO: Should just add all automatically
    programs.neovim.ftPlugins =
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

    xdg.configFile."nvim/lsp.lua".text = luaLsp;
    xdg.configFile."nvim/treesitter.lua".text = treesitter;

    programs.neovim.configure = {
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
          pkgs.vimPlugins.limelight-vim
          pkgs.vimPlugins.vim-mundo
          pkgs.vimPlugins.goyo-vim
          plugins.sad
          plugins.vim-scratch
          plugins.vim-colortemplate
          plugins.vim-cool
          plugins.vim-visual-split
          plugins.vim-matchup
          plugins.vim-qf
          plugins.fern

          # Git
          pkgs.vimPlugins.vim-fugitive
          pkgs.vimPlugins.gv-vim
          pkgs.vimPlugins.vim-rhubarb

          # Language Tooling
          plugins.parinfer-rust
          plugins.vim-markdown-folding
          plugins.conjure

          # Themes
          plugins.onehalf
          plugins.apprentice
          pkgs.vimPlugins.iceberg-vim
          pkgs.vimPlugins.papercolor-theme
          plugins.yui
          plugins.spacevim
          plugins.vim-one-theme

          # Languages & Syntax
          pkgs.vimPlugins.purescript-vim
          pkgs.vimPlugins.vim-nix
          pkgs.vimPlugins.dhall-vim
          plugins.vim-js
          plugins.vim-lua
          pkgs.vimPlugins.yats-vim
          pkgs.vimPlugins.vim-jsx-pretty

          treesitterGo
        ]
        ++ localPlugins;

        opt = [
          plugins.nvim-treesitter
          plugins.nvim-lsp
        ];
      };
    };
  };
}
