# Lots of things are commented out because right now I don't want to have half
# of my programs coming from pacman and the other half from home manager
{ pkgs, ... }:
let
  shared = import ../../shared.nix;

  programs = import ../../programs/default.nix;

  clojure = import ../../languages/clojure/default.nix;

  sources = import ../../nix/sources.nix;

  pkgs = import sources.nixpkgs { };

in
{
  imports = [
    programs.nvim.config
    programs.fish.config
    programs.redshift.config
    clojure.config
    programs.fzf.config
    programs.tmux.config
    programs.git.config
  ];

  home.packages = with pkgs; shared.pkgs ++ [
    iotop
    xclip
    neofetch
    jrnl
  ];

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix)
  ];


  # https://github.com/rycee/home-manager/blob/master/modules/targets/generic-linux.nix#blob-path
  targets.genericLinux.enable = true;

  # TODO: alacritty.config like with neovim but merge with enable = false
  # programs.alacritty.enable = false;
  # xdg.configFile."alacritty/alacritty.yml".source = (import ../../programs/alacritty/default.nix).linux;

  services.lorri.enable = true;
  services.lorri.package = pkgs.lorri;

  programs.fzf.enable = true;

  programs.home-manager = {
    enable = true;
  };

  # https://gist.github.com/peti/2c818d6cb49b0b0f2fd7c300f8386bc3
  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  home.stateVersion = "20.03";
}
