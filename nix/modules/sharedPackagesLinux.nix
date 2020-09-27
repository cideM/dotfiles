{ pkgs, ... }:

with pkgs;

{
  home.packages = [
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
