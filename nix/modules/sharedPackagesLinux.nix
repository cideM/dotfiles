{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    libnotify
    iotop
    xclip
    feh
    escrotum
    kanji-stroke-order-font
    source-han-sans-japanese
    source-han-serif-japanese
    iosevka
  ];
}
