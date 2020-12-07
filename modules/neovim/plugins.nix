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
      "rev" = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
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
      "rev" = "258751d666d31888f97ca6188a686f36fadf6c43";
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
      "rev" = "73afadbd117a8e8551758af9c3a522ef46452119";
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
      "rev" = "73afadbd117a8e8551758af9c3a522ef46452119";
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

  nvim-tree-lua = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "nvim-tree-lua";
    src = sources."nvim-tree-lua";
  });

  completion-nvim = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "completion-nvim";
    src = sources."completion-nvim";
  });

  edge = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "edge";
    src = sources."vim-color-edge";
  });

  onebuddy = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "onebuddy";
    src = sources."onebuddy";
  });

  telescope = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "telescope";
    src = sources."nvim-telescope";
  });

  plenary = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "plenary";
    src = sources."nvim-plenary";
  });

  popup = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "popup";
    src = sources."nvim-popup";
  });

  colorbuddy = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "colorbuddy";
    src = sources."nvim-colorbuddy";
  });

  completion-buffers = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "completion-buffers";
    src = sources."nvim-completion-buffers";
  });

  fern = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "fern";
    src = sources."nvim-fern";
  });

  gina = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "gina";
    src = sources."nvim-gina";
  });

  any-jump = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "any-jump";
    src = sources."nvim-any-jump";
  });

  sonokai = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "sonokai";
    src = sources."nvim-color-sonokai";
  });

  highlite = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "highlite";
    src = sources."nvim-highlite";
  });

  completion-tags = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "completion-tags";
    src = sources."nvim-completion-tags";
  });

in
{
  inherit
    apprentice
    completion-nvim
    conjure
    edge
    nvim-colorizer
    nvim-lsp
    nvim-tree-lua
    nvim-treesitter
    fern
    onehalf
    any-jump
    completion-tags
    onebuddy
    completion-buffers
    highlite
    sonokai
    gina
    parinfer-rust
    sad
    colorbuddy
    spacevim
    plenary
    popup
    telescope
    treesitterGo
    treesitterTs
    treesitterTsx
    treesitterYaml
    vim-colortemplate
    vim-js
    vim-lua
    vim-markdown-folding
    vim-matchup
    vim-one-theme
    vim-scratch
    vim-startuptime
    vim-terraform
    vim-visual-split
    yui;
}
