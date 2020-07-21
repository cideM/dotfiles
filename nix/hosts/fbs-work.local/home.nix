# Lots of things are commented out because right now I don't want to have half
# of my programs coming from pacman and the other half from home manager
{ pkgs, ... }:

let
  # shared = import ../../shared.nix;

  programs = import ../../programs/default.nix;

  clojure = import ../../languages/clojure/default.nix;

  sources = import ../../nix/sources.nix;

  pkgs = import sources.nixpkgs {};

in {
  imports = [
    programs.nvim.config
    programs.fish.config
    programs.redshift.config
    clojure.config
    programs.fzf.config
    programs.tmux.config
    programs.git.config
  ];

  # home.packages = with pkgs; shared.pkgs ++ [
  #   iotop
  #   xclip
  #   neofetch
  #   jrnl
  # ];
  home.packages = with pkgs; [
    niv
  ];

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix)
  ];

  # TODO: alacritty.config like with neovim but merge with enable = false
  # programs.alacritty.enable = false;
  # xdg.configFile."alacritty/alacritty.yml".source = (import ../../programs/alacritty/default.nix).linux;

  programs.fzf.enable = true;

  programs.home-manager = {
    enable = true;
  };

  home.stateVersion = "20.03";
}
