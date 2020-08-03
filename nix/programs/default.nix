let
  alacritty = import ./alacritty/default.nix;

  fish = import ./fish/default.nix;

  fzf = import ./fzf/default.nix;

  git = import ./git/default.nix;

  nvim = import ./neovim/default.nix;

  redshift = import ./redshift/default.nix;

  tmux = import ./tmux/default.nix;

  ctags = import ./ctags/default.nix;

  pandoc = import ./pandoc/default.nix;
in
{
  inherit alacritty fish fzf git nvim redshift tmux ctags pandoc;
}
