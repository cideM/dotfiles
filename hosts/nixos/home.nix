{ pkgs, ... }:
{
  imports = [
    (import ../../modules/neovim.nix)
    (import ../../modules/git.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/kitty)
    (import ../../modules/common.nix)
  ];

  home.packages = with pkgs; [
    iotop
    xsel
    discord
    insomnia
    spotify
    zathura
    obsidian

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
}
