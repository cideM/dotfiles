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
  conjure = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "conjure";
    src = sources.conjure;
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

  neovim-set-path = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "neovim-set-path";
    src = sources.neovim-set-path;
  });

  qfenter = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "qfenter";
    src = sources.qfenter;
  });

  flog = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "flog";
    src = sources.flog;
  });

  suda.vim = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "suda.vim";
    src = sources."suda.vim";
  });

  vim-markdown-toc = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-markdown-toc";
    src = sources.vim-markdown-toc;
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

  sad = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "sad";
    src = sources.sad;
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

  fennel-vim = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "fennel-vim";
    src = sources."fennel-vim";
  });

  vim-kuroi-colors = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-kuroi-colors";
    src = sources."vim-kuroi-colors";
  });

  unicode-vim = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "unicode-vim";
    src = sources."unicode-vim";
  });

  conjure-compe = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "conjure-compe";
    src = sources.compe-conjure;
  });

  nvim-compe = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-compe";
    src = sources.nvim-compe;
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
    includedFiles = [ "parser.c" "scanner.cc" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/cstrahan/tree-sitter-nix";
      "ref" = "master";
      "rev" = "791b5ff0e4f0da358cbb941788b78d436a2ca621";
      }}/src";
  };

  grammarClojure = makeGrammar {
    parserName = "clojure";
    includedFiles = [ "parser.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/sogaiu/tree-sitter-clojure";
      "ref" = "master";
      "rev" = "f09652f095be878df8a87a57dcbfa07094316253";
      }}/src";
  };

  grammarYaml = makeGrammar {
    parserName = "yaml";
    includedFiles = [ "parser.c" "scanner.cc" ];
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/ikatyang/tree-sitter-yaml";
      "rev" = "ab0ce67ce98f8d9cc0224ebab49c64d01fedc1a1";
      }}/src";
  };

  grammarGo = makeGrammar {
    includedFiles = [ "parser.c" ];
    parserName = "go";
    src = "${builtins.fetchGit {
      "url" = "https://git@github.com/tree-sitter/tree-sitter-go.git";
      "ref" = "master";
      "rev" = "dadfd9c9aab2630632e61cfce645c13c35aa092f";
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
      "rev" = "2a0aa1cb5f1b787a4056a29fa0791e87846e33fb";
      }}/src";
  };

  grammarPython = makeGrammar {
    parserName = "python";
    includedFiles = [ "parser.c" "scanner.cc" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/tree-sitter/tree-sitter-python";
      "ref" = "master";
      "rev" = "f568dfabf7c4611077467a9cd13297fa0658abb6";
      }}/src";
  };

  grammarJavascript = makeGrammar {
    parserName = "javascript";
    includedFiles = [ "parser.c" "scanner.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/tree-sitter/tree-sitter-javascript";
      "ref" = "master";
      "rev" = "852f11b394804ac2a8986f8bcaafe77753635667";
      }}/src";
  };

  grammarTs = makeGrammar {
    includedFiles = [ "parser.c" "scanner.c" ];
    parserName = "typescript";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "73afadbd117a8e8551758af9c3a522ef46452119";
      }}/typescript/src";
  };

  grammarTsx = makeGrammar {
    includedFiles = [ "parser.c" "scanner.c" ];
    parserName = "tsx";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "73afadbd117a8e8551758af9c3a522ef46452119";
    }}/tsx/src";
  };

}
