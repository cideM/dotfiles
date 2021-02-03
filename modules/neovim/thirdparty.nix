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

  nvim-compe = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "nvim-compe";
    src = sources.nvim-compe;
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

  conjure-compe = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "conjure-compe";
    src = sources.conjure-compe;
  vim-markdown-toc = (pkgs.vimUtils.buildVimPluginFrom2Nix {
    name = "vim-markdown-toc";
    src = sources.vim-markdown-toc;
  });
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

  nvim-treesitter = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "nvim-treesitter";
    src = sources.nvim-treesitter;
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

  vim-nightowl-colors = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-nightowl-colors";
    src = sources."vim-nightowl-colors";
  });

  vim-tokyonight-colors = (pkgs.vimUtils.buildVimPluginFrom2Nix rec {
    name = "vim-tokyonight-colors";
    src = sources."vim-tokyonight-colors";
  });

};
