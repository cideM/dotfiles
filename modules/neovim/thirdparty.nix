{ config, lib, pkgs, ... }:

with builtins;
let
  cfg = config.programs.neovim;

  sources = config.sources;

  makeGrammar =
    { includedFiles
    , parserName
    , src
    , name ? parserName
    , version ? "latest"
    }:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      version = version;
      name = "nvim-treesitter-${name}";
      src = src;
      buildPhase = ''
        runHook preBuild
        mkdir -p parser/
        ${pkgs.gcc}/bin/gcc -o parser/${parserName}.so -I$src/ ${builtins.concatStringsSep " " includedFiles}  -shared  -Os -lstdc++ -fPIC
        runHook postBuild
      '';
    };

  installFromBuiltGrammars = { src, parserFileName }:
    pkgs.vimUtils.buildVimPluginFrom2Nix {
      version = "latest";
      dontUnpack = true;
      name = "nvim-treesitter-${parserFileName}";
      src = src;
      buildPhase = ''
        mkdir -p parser/
        cp $src parser/${parserFileName}.so
      '';
    };

in
{
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

  feline = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "feline.nvim";
    src = sources."feline.nvim";
  });

  nvim-lspfuzzy = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "nvim-lspfuzzy";
    src = sources."nvim-lspfuzzy";
  });

  diffview = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "diffview";
    src = sources."diffview.nvim";
  });

  conflict-marker = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "conflict-marker";
    src = sources."conflict-marker.vim";
  });

  sad = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "sad";
    src = sources.sad;
  });

  nvim-hlslens = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-hlslens";
    src = sources.nvim-hlslens;
  });

  vim_current_word = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim_current_word";
    src = sources.vim_current_word;
  });

  nvim-cursorline = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-cursorline";
    src = sources.nvim-cursorline;
  });

  nvim-compe = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-compe";
    src = sources.nvim-compe;
  });

  indent-blankline = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "indent-blankline";
    src = sources."indent-blankline.nvim";
  });

  nvim-treesitter = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-treesitter";
    src = sources.nvim-treesitter;
  });

  neovim-set-path = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "neovim-set-path";
    src = sources.neovim-set-path;
  });

  qfenter = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "qfenter";
    src = sources.qfenter;
  });

  suda.vim = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "suda.vim";
    src = sources."suda.vim";
  });

  inspecthi = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "inspecthi";
    src = sources.inspecthi;
  });

  nvim-lsp = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-lsp";
    src = sources.nvim-lsp;
  });

  vim-markdown-folding = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-markdown-folding";
    src = sources.vim-markdown-folding;
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

  vim-js = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-js";
    src = sources.vim-js;
  });

  vim-lua = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-lua";
    src = sources.vim-lua;
  });

  vim-terraform = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-terraform";
    src = sources.vim-terraform;
  });

  vim-colors-github = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-colors-github";
    src = sources."vim-colors-github";
  });

  unicode-vim = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "unicode-vim";
    src = sources."unicode-vim";
  });

  vim-nightowl-colors = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-nightowl-colors";
    src = sources."vim-nightowl-colors";
  });

  vim-tokyonight-colors = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-tokyonight-colors";
    src = sources."vim-tokyonight-colors";
  });

  # TODO: Add all from https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lua/nvim-treesitter/parsers.lua
  # TODO: Add them to nixpkgs once I've figured out how
  # https://github.com/nvim-treesitter/nvim-treesitter/blob/master/lockfile.json
  grammarNix = makeGrammar {
    parserName = "nix";
    includedFiles = [ "parser.c" "scanner.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/cstrahan/tree-sitter-nix";
      "ref" = "master";
      "rev" = "d5287aac195ab06da4fe64ccf93a76ce7c918445";
      }}/src";
  };

  grammarClojure = makeGrammar {
    parserName = "clojure";
    includedFiles = [ "parser.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/sogaiu/tree-sitter-clojure";
      "ref" = "master";
      "rev" = "f7d100c4fbaa8aad537e80c7974c470c7fb6aeda";
      }}/src";
  };

  grammarYaml = makeGrammar {
    parserName = "yaml";
    includedFiles = [ "parser.c" "scanner.cc" ];
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/ikatyang/tree-sitter-yaml";
      "rev" = "6129a83eeec7d6070b1c0567ec7ce3509ead607c";
      }}/src";
  };

  grammarGo = makeGrammar {
    includedFiles = [ "parser.c" ];
    parserName = "go";
    src = "${builtins.fetchGit {
      "url" = "https://git@github.com/tree-sitter/tree-sitter-go.git";
      "ref" = "master";
      "rev" = "2a2fbf271ad6b864202f97101a2809009957535e";
      }}/src";
  };

  grammarJson = installFromBuiltGrammars {
    parserFileName = "json";
    src = "${pkgs.tree-sitter.builtGrammars.tree-sitter-json}/parser";
  };

  grammarHaskell = makeGrammar {
    includedFiles = [ "parser.c" "scanner.cc" ];
    parserName = "haskell";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://github.com/tree-sitter/tree-sitter-haskell";
      "rev" = "2e33ffa3313830faa325fe25ebc3769896b3a68b";
      }}/src";
  };

  grammarPython = makeGrammar {
    parserName = "python";
    includedFiles = [ "parser.c" "scanner.cc" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/tree-sitter/tree-sitter-python";
      "ref" = "master";
      "rev" = "d6210ceab11e8d812d4ab59c07c81458ec6e5184";
      }}/src";
  };

  grammarJavascript = makeGrammar {
    parserName = "javascript";
    includedFiles = [ "parser.c" "scanner.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/tree-sitter/tree-sitter-javascript";
      "ref" = "master";
      "rev" = "a263a8f53266f8f0e47e21598e488f0ef365a085";
      }}/src";
  };

  grammarTs = makeGrammar {
    includedFiles = [ "parser.c" "scanner.c" ];
    parserName = "typescript";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "d0c785782a4384034d4a6460b908141a88ad7229";
      }}/typescript/src";
  };

  grammarTsx = makeGrammar {
    includedFiles = [ "parser.c" "scanner.c" ];
    parserName = "tsx";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "d0c785782a4384034d4a6460b908141a88ad7229";
    }}/tsx/src";
  };

}
