{pkgs, ...}: {
  imports = [
    (import ../../modules/neovim.nix)
    (import ../../modules/git.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/common.nix)
    (import ../../modules/alacritty)
    (import ../../modules/vim.nix)
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
    pavucontrol
    _1password-gui

    gnome.gnome-tweaks

    sublime-merge

    ledger-live-desktop
    openvpn

    kanji-stroke-order-font

    noto-fonts-emoji

    source-han-sans
    source-han-serif

    roboto
    roboto-mono

    firefox-wayland

    slack
  ];

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';

  xdg.configFile.".gemrc".text = ''
    :ipv4_fallback_enabled: true
  '';
}
