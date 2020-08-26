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

in
{
  inherit
    sad
    yui
    spacevim
    edge-theme
    conjure
    nvim-lsp
    vim-markdown-folding
    parinfer-rust
    onehalf
    apprentice
    vim-colortemplate
    vim-cool
    vim-matchup
    vim-scratch
    vim-js
    vim-qf;
}
