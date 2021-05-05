{ pkgs, ... }:
{
  imports = [
    (import ../../modules/alacritty.nix)
    # (import ../../modules/neovim)
    (import ../../modules/neovim_simple)
    (import ../../modules/git.nix)
    (import ../../modules/tmux)
    (import ../../modules/redshift.nix)
    (import ../../modules/ctags.nix)
    (import ../../modules/pandoc)
    (import ../../modules/fish)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedSettings.nix)
    (import ../../modules/sources.nix)
    (import ../../modules/vscode)
  ];

  sources = import ../../nix/sources.nix;

  home.packages = with pkgs; [
    iotop
    xsel
    kanji-stroke-order-font
    cachix
    source-han-sans-japanese
    source-han-serif-japanese
    iosevka
    kazam
    insomnia
    (import ../../derivations/kubectl.nix {
      inherit (pkgs) stdenv;
      inherit (builtins) fetchurl;
    })
    sublime-merge
    spotify
    gnupg
    zotero
    zoom-us
    mupdf
    okular
    zathura
    slack
    anki
    jetbrains.clion
    jetbrains.rider
    jetbrains.webstorm
    nerdfonts
    android-studio
    jetbrains.idea-ultimate
    jetbrains.goland
    jetbrains.pycharm-professional
    skype
  ];

  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.alacritty = {
    light = true;
    font = "mono";
    enable = true;
    fontSize = 11;
  };

  # Just append this to the actual config file with an overlay
  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR ~/notes_new
    set -x FISH_WORK_NOTES ~/work_notes
  '';

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "${pkgs.xsel}/bin/xsel -i --clipboard"
  '';
}
