{pkgs, ...}: {
  imports = [
    (import ../../modules/neovim)
    (import ../../modules/git.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/common.nix)
    (import ../../modules/alacritty)
    (import ../../modules/vim.nix)
    (import ../../modules/ghostty.nix)
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
    _1password-gui
    firefox-wayland
    ghostty
    gnome-tweaks
    iotop
    kanji-stroke-order-font
    ledger-live-desktop
    noto-fonts-emoji
    openvpn
    pavucontrol
    roboto
    roboto-mono
    slack
    source-han-sans
    source-han-serif
    sublime-merge
    xsel
  ];

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';

  xdg.configFile.".gemrc".text = ''
    :ipv4_fallback_enabled: true
  '';
}
