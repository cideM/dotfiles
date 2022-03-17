{ pkgs, ... }:
{
  imports = [
    (import ../../modules/neovim.nix)
    (import ../../modules/git.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/kitty)
    (import ../../modules/common.nix)
    (import ../../modules/alacritty)
    (import ../../modules/vscode)
  ];

  programs.alacritty.settings.font.size = 10;
  programs.alacritty.enable = true;

  home.packages = with pkgs; [
    iotop
    xsel
    discord
    audacity
    insomnia
    spotify
    zathura
    obsidian
    gimp
    simplescreenrecorder

    gnome.gnome-tweaks

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

    firefox
    google-chrome

    zoom-us
    slack
  ];

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';
}
