{ pkgs, ... }:
{
  imports = [
    (import ../../modules/neovim.nix)
    (import ../../modules/git.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/kitty)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedSettings.nix)
  ];

  home.packages = with pkgs; [
    iotop
    xsel
    discord
    insomnia
    spotify
    zathura

    sublime-merge
    sublime4

    ledger-live-desktop
    openvpn

    kanji-stroke-order-font

    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese

    roboto
    roboto-mono

    liberation_ttf

    firefox-devedition-bin
    google-chrome

    zoom-us
    slack
  ];

  # > cannot find executable file `/nix/store/r5c5mj2z8h8k744jzpycxmzqsabq232n-firefox-devedition-bin-85.0b6/bin/firefox-devedition-bin'
  # sigh
  programs.firefox.enable = false;
  programs.firefox.package = pkgs.firefox-devedition-bin;
}
