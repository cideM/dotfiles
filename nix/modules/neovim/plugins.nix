# TODO: Add to Nixpkgs on GitHub
{ pkgs, ... }:
let
  vimPluginsSources = import ./nix/sources.nix;

  conjure = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "conjure";
    src = vimPluginsSources.conjure;
  });

  nvim-lsp = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lsp";
    src = vimPluginsSources.nvim-lsp;
  });

  vim-markdown-folding = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-markdown-folding";
    src = vimPluginsSources.vim-markdown-folding;
  });

  parinfer-rust = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "parinfer";
    postInstall = ''
      rtpPath=$out/share/vim-plugins/${name}
      mkdir -p $rtpPath/plugin
      sed "s,let s:libdir = .*,let s:libdir = '${pkgs.parinfer-rust}/lib'," \
        plugin/parinfer.vim >$rtpPath/plugin/parinfer.vim
    '';
    src = vimPluginsSources.parinfer;
  });

  onehalf = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "onehalf";
    src = "${vimPluginsSources.onehalf}/vim";
  });

  apprentice = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "apprentice";
    src = vimPluginsSources.Apprentice;
  });

  vim-colortemplate = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-colortemplate";
    src = vimPluginsSources.vim-colortemplate;
  });

  vim-cool = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-cool";
    src = vimPluginsSources.vim-cool;
  });

  vim-matchup = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-matchup";
    src = vimPluginsSources.vim-matchup;
  });

  vim-qf = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-qf";
    src = vimPluginsSources.vim-qf;
  });

  edge-theme = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "edge-theme";
    src = vimPluginsSources.edge-theme;
  });

  # This is the spacevim theme not the spacevim plugin
  spacevim = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "spacevim";
    src = vimPluginsSources.spacevim;
  });

  yui = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "yui";
    src = vimPluginsSources.yui;
  });

  sad = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "sad";
    src = vimPluginsSources.sad;
  });

  vim-scratch = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-scratch";
    src = vimPluginsSources.vim-scratch;
  });

  vim-js = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-js";
    src = vimPluginsSources.vim-js;
  });

  fern = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "fern";
    src = vimPluginsSources.vim-fern;
  });

  vim-visual-split = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-visual-split";
    src = vimPluginsSources.vim-visual-split;
  });

  vim-one-theme = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-one-theme";
    src = vimPluginsSources.vim-one-colors;
  });

  nvim-treesitter = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "nvim-treesitter";
    src = vimPluginsSources.nvim-treesitter;
  });

  vim-lua = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-lua";
    src = vimPluginsSources.vim-lua;
  });

  # TODO: Add all from https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
  # TODO: Add them to nixpkgs once I've figured out how
  treesitterGo = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-go-${version}";
    src = vimPluginsSources.treesitter-go;
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/go.so -I$src/src $src/src/parser.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  treesitterYaml = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-yaml-${version}";
    src = vimPluginsSources.treesitter-yaml;
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/yaml.so -I$src/src $src/src/parser.c $src/src/scanner.cc -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  treesitterTs = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-ts-${version}";
    src = vimPluginsSources.treesitter-ts;
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/typescript.so -I$src/typescript/src $src/typescript/src/parser.c $src/typescript/src/scanner.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  treesitterTsx = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-tsx-${version}";
    src = vimPluginsSources.treesitter-ts;
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/tsx.so -I$src/tsx/src $src/tsx/src/parser.c $src/tsx/src/scanner.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  nvim-colorizer = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "nvim-colorizer";
    src = vimPluginsSources.nvim-colorizer;
  });

in
{
  inherit
    apprentice
    conjure
    edge-theme
    fern
    nvim-lsp
    onehalf
    parinfer-rust
    sad
    spacevim
    vim-colortemplate
    vim-one-theme
    vim-cool
    vim-js
    vim-markdown-folding
    vim-matchup
    vim-lua
    vim-qf
    vim-scratch
    vim-visual-split
    treesitterGo
    treesitterYaml
    treesitterTs
    treesitterTsx
    nvim-treesitter
    nvim-colorizer
    yui;
}
