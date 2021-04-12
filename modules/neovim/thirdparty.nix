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

  nvim-treesitter = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-treesitter";
    src = sources.nvim-treesitter;
  });

  neovim-set-path = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "neovim-set-path";
    src = sources.neovim-set-path;
  });

  indent-blankline = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "indent-blankline";
    src = sources.indent-blankline;
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
    includedFiles = [ "parser.c" "scanner.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/cstrahan/tree-sitter-nix";
      "ref" = "master";
      "rev" = "a6bae0619126d70c756c11e404d8f4ad5108242f";
      }}/src";
  };

  grammarClojure = makeGrammar {
    parserName = "clojure";
    includedFiles = [ "parser.c" ];
    src = "${builtins.fetchGit {
      "url" = "https://github.com/sogaiu/tree-sitter-clojure";
      "ref" = "master";
      "rev" = "95c7959c461406381b42113dcf4591008c663d21";
      }}/src";
  };

  grammarYaml = makeGrammar {
    parserName = "yaml";
    includedFiles = [ "parser.c" "scanner.cc" ];
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/ikatyang/tree-sitter-yaml";
      "rev" = "2240ccd0538c8f41394b9cd2202a175b1660b8d6";
      }}/src";
  };

  grammarGo = makeGrammar {
    includedFiles = [ "parser.c" ];
    parserName = "go";
    src = "${builtins.fetchGit {
      "url" = "https://git@github.com/tree-sitter/tree-sitter-go.git";
      "ref" = "master";
      "rev" = "2a83dfdd759a632651f852aa4dc0af2525fae5cd";
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
      "rev" = "381dca04f20381ecb3f4306d727474755ad19cc4";
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
      "rev" = "4a95461c4761c624f2263725aca79eeaefd36cad";
      }}/src";
  };

  grammarTs = makeGrammar {
    includedFiles = [ "parser.c" "scanner.c" ];
    parserName = "typescript";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "89e720e354f02976cc63f3c8c3e55773fceed3d2";
      }}/typescript/src";
  };

  grammarTsx = makeGrammar {
    includedFiles = [ "parser.c" "scanner.c" ];
    parserName = "tsx";
    src = "${builtins.fetchGit {
      "ref" = "master";
      "url" = "https://git@github.com/tree-sitter/tree-sitter-typescript";
      "rev" = "89e720e354f02976cc63f3c8c3e55773fceed3d2";
    }}/tsx/src";
  };

}
