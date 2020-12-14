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
    source-han-serif-japanese
    iosevka
    # I'd add this in Neovim but it doesn't work on Darwin and I'm too lazy to
    # write a conditional
    clj-kondo

    # GUI stuff
    insomnia # only on Linux

  ];
}
