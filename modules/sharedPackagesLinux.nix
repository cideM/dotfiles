{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    libnotify
    iotop
    xsel
    feh
    escrotum
    kanji-stroke-order-font
    source-han-sans-japanese
    obs-studio
    source-han-serif-japanese
    iosevka

    # GUI stuff
    insomnia # only on Linux

  ];
}
