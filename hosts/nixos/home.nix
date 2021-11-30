{ pkgs, ... }:
{
  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/git.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedSettings.nix)
    (import ../../modules/vscode/default.nix)
  ];

  home.packages = with pkgs; [
    iotop
    kanji-stroke-order-font
    # Broken on Darwin
    xsel
    discord
    kazam
    okular
    google-chrome
    insomnia
    cmus
    spotify
    zotero
    jetbrains.webstorm
    zathura
    android-studio
    jetbrains.goland
    skype
    sublime-merge
    sublime4
    ledger-live-desktop
    pulseaudio
    pavucontrol
    alsa-utils
    openvpn

    source-han-sans
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji

    source-han-sans-japanese
    source-han-serif-japanese
    firefox-devedition-bin
    zoom-us
    slack
  ];

  # > cannot find executable file `/nix/store/r5c5mj2z8h8k744jzpycxmzqsabq232n-firefox-devedition-bin-85.0b6/bin/firefox-devedition-bin'
  # sigh
  programs.firefox.enable = false;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.alacritty.settings.font.size = 12;

  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR ~/notes_new
    set -x FISH_WORK_NOTES ~/work_notes
  '';

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';
}
