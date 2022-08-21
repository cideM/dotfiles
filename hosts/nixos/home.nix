{ pkgs, ... }:
{
  imports = [
    (import ../../modules/neovim.nix)
    (import ../../modules/git.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/common.nix)
    (import ../../modules/alacritty)
  ];

  home.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  programs.alacritty.settings.font.size = 10;
  programs.alacritty.enable = true;

  home.stateVersion = "20.09";

  home.packages = with pkgs; [
    iotop
    xsel
    insomnia
    pavucontrol
    spotify
    obsidian

    gnome.gnome-tweaks

    sublime-merge
    sublime4

    ledger-live-desktop
    openvpn

    kanji-stroke-order-font

    noto-fonts-emoji

    source-han-sans
    source-han-sans-japanese
    source-han-serif-japanese

    roboto
    roboto-mono

    firefox
    google-chrome

    slack
  ];

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';
}
