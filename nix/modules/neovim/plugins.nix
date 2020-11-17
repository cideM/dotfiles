# TODO: Add to Nixpkgs on GitHub
{ pkgs, sources, ... }:
let
  conjure = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "conjure";
    src = sources.conjure;
  });

  nvim-lsp = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lsp";
    src = sources.nvim-lsp;
  });

  vim-markdown-folding = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-markdown-folding";
    src = sources.vim-markdown-folding;
  });

  parinfer-rust = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "parinfer";
    postInstall = ''
      rtpPath=$out/share/vim-plugins/${name}
      mkdir -p $rtpPath/plugin
      sed "s,let s:libdir = .*,let s:libdir = '${pkgs.parinfer-rust}/lib'," \
        plugin/parinfer.vim >$rtpPath/plugin/parinfer.vim
    '';
    src = sources.parinfer;
  });

  onehalf = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "onehalf";
    src = "${sources.onehalf}/vim";
  });

  apprentice = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "apprentice";
    src = sources.Apprentice;
  });

  vim-colortemplate = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-colortemplate";
    src = sources.vim-colortemplate;
  });

  vim-matchup = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-matchup";
    src = sources.vim-matchup;
  });

  # This is the spacevim theme not the spacevim plugin
  spacevim = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "spacevim";
    src = sources.spacevim;
  });

  yui = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "yui";
    src = sources.yui;
  });

  sad = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "sad";
    src = sources.sad;
  });

  vim-scratch = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-scratch";
    src = sources.vim-scratch;
  });

  vim-js = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-js";
    src = sources.vim-js;
  });

  vim-visual-split = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-visual-split";
    src = sources.vim-visual-split;
  });

  vim-one-theme = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-one-theme";
    src = sources.vim-one-colors;
  });

  nvim-treesitter = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "nvim-treesitter";
    src = sources.nvim-treesitter;
  });

  vim-lua = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-lua";
    src = sources.vim-lua;
  });

  # TODO: Add all from https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
  # TODO: Add them to nixpkgs once I've figured out how
  treesitterGo = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-go-${version}";
    src = builtins.fetchGit {
      "url" = "https://git@github.com/tree-sitter/tree-sitter-go.git";
      "ref" = "master";
      "rev" = "34181774b3e86b7801c939c79c7b80a82df91a2b";
    };
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
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/ikatyang/tree-sitter-yaml";
      "rev" = "b26d567070cfb40cb3138a57cf12a4e2e3c854ef";
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      ${pkgs.clang}/bin/clang++ -o parser/yaml.so -I$src/src $src/src/parser.c $src/src/scanner.cc -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  treesitterTs = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-ts-${version}";
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "07a12bdf024d66d267bd7f96870f8bbbaceaa5d9";
    };
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
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "07a12bdf024d66d267bd7f96870f8bbbaceaa5d9";
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/tsx.so -I$src/tsx/src $src/tsx/src/parser.c $src/tsx/src/scanner.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  nvim-colorizer = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "nvim-colorizer";
    src = sources.nvim-colorizer;
  });

  vim-terraform = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-terraform";
    src = sources.vim-terraform;
  });

  vim-startuptime = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-startuptime";
    src = sources.vim-startuptime;
  });

in
{
  inherit
    apprentice
    conjure
    nvim-lsp
    onehalf
    parinfer-rust
    sad
    spacevim
    vim-colortemplate
    vim-one-theme
    vim-js
    vim-markdown-folding
    vim-matchup
    vim-lua
    vim-scratch
    vim-terraform
    vim-startuptime
    vim-visual-split
    treesitterGo
    treesitterYaml
    treesitterTs
    treesitterTsx
    nvim-treesitter
    nvim-colorizer
    yui;
}
