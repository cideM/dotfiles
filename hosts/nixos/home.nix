{ pkgs, ... }:
{
  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/neovim.nix)
    (import ../../modules/git.nix)
    (import ../../modules/tmux.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/pandoc.nix)
    (import ../../modules/fish.nix)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedSettings.nix)
    (import ../../modules/sources.nix)
    (import ../../modules/vscode.nix)
  ];

  sources = import ../../nix/sources.nix;

  home.packages = with pkgs; [
    iotop
    kanji-stroke-order-font
    cachix
    source-han-sans-japanese
    source-han-serif-japanese
    iosevka
    kazam
    insomnia
    kubectl
    sublime-merge
    spotify
    gnupg
    zotero
    zoom-us
    okular
    zathura
    delta
    slack
    discord
    jetbrains.webstorm
    nerdfonts
    android-studio
    jetbrains.goland
    skype
  ];

  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.alacritty = {
    light = true;
    disableScaling = false;
    font = "mono";
    enable = true;
    fontSize = 11;
  };

  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR ~/notes_new
    set -x FISH_WORK_NOTES ~/work_notes
  '';

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';
}
