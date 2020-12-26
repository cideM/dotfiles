{ config, lib, pkgs, ... }:
let
  cfg = config.programs.neovim;

  sources = config.sources;
in
{
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

  # parinfer-rust = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
  #   name = "parinfer";
  #   postInstall = ''
  #     rtpPath=$out/share/vim-plugins/${name}
  #     mkdir -p $rtpPath/plugin
  #     sed "s,let s:libdir = .*,let s:libdir = '${pkgs.parinfer-rust}/lib'," \
  #       plugin/parinfer.vim >$rtpPath/plugin/parinfer.vim
  #   '';
  #   src = sources.parinfer;
  # });

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

  nvim-treesitter = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "nvim-treesitter";
    src = sources.nvim-treesitter;
  });

  vim-lua = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-lua";
    src = sources.vim-lua;
  });

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

  vim-colors-github = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-colors-github";
    src = sources."vim-colors-github";
  });

  fennel-vim = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "fennel-vim";
    src = sources."fennel-vim";
  });

  vim-kuroi-colors = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-kuroi-colors";
    src = sources."vim-kuroi-colors";
  });

  vim-nightowl-colors = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-nightowl-colors";
    src = sources."vim-nightowl-colors";
  });

  vim-tokyonight-colors = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-tokyonight-colors";
    src = sources."vim-tokyonight-colors";
  });

  ###################################
  #       TREESITTER GRAMMARS       #
  ###################################
  # TODO: Add all from https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
  # TODO: Add them to nixpkgs once I've figured out how
  grammarNix = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-nix-${version}";
    src = builtins.fetchGit {
      "url" = "https://github.com/cstrahan/tree-sitter-nix";
      "ref" = "master";
      "rev" = cfg.treesitter.nix.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/nix.so -I$src/src $src/src/parser.c $src/src/scanner.cc -shared  -Os -fPIC
      runHook postBuild
    '';
  };

  grammarGo = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-go-${version}";
    src = builtins.fetchGit {
      "url" = "https://git@github.com/tree-sitter/tree-sitter-go.git";
      "ref" = "master";
      "rev" = cfg.treesitter.go.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/go.so -I$src/src $src/src/parser.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  grammarClojure = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-clojure-${version}";
    src = builtins.fetchGit {
      "url" = "https://github.com/sogaiu/tree-sitter-clojure";
      "ref" = "master";
      "rev" = cfg.treesitter.clojure.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/clojure.so -I$src/src $src/src/parser.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  grammarYaml = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-yaml-${version}";
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/ikatyang/tree-sitter-yaml";
      "rev" = cfg.treesitter.yaml.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      ${pkgs.clang}/bin/clang++ -o parser/yaml.so -I$src/src $src/src/parser.c $src/src/scanner.cc -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  grammarTs = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-ts-${version}";
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = cfg.treesitter.ts.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/typescript.so -I$src/typescript/src $src/typescript/src/parser.c $src/typescript/src/scanner.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };

  grammarTsx = pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    version = "latest";
    name = "tree-sitter-tsx-${version}";
    src = builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = cfg.treesitter.tsx.rev;
    };
    buildPhase = ''
      runHook preBuild
      mkdir -p parser/
      $CC -o parser/tsx.so -I$src/tsx/src $src/tsx/src/parser.c $src/tsx/src/scanner.c -shared  -Os -lstdc++ -fPIC
      runHook postBuild
    '';
  };
}
