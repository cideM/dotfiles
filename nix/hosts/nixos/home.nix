{ pkgs, ... }:

{
  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/neovim)
    (import ../../modules/git.nix)
    (import ../../modules/redshift.nix)
    (import ../../modules/fcitx.nix)
    (import ../../modules/tmux)
    (import ../../modules/ctags.nix)
    (import ../../modules/clojure)
    (import ../../modules/pandoc)
    (import ../../modules/fish)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedPackagesLinux.nix)
    (import ../../modules/sharedSettings.nix)
    (import ../../modules/goland)
    (import ../../modules/vscode)
  ];

  home.packages = with pkgs; [
    insomnia
    spotify
    zoom-us
    slack
    jetbrains.webstorm
    jetbrains.clion
    jetbrains.rider
    anki
    jetbrains.pycharm-professional
  ];

  # On first install this needs to be disabled for allowUnfree to work. I
  # shouldn't have to do this but nothing in
  # https://github.com/rycee/home-manager/issues/463 works
  programs.firefox.enable = true;
  programs.firefox.package = pkgs.firefox-devedition-bin;

  programs.alacritty.enable = true;

  # Just append this to the actual config file with an overlay
  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  xdg.mime.enable = true;

  services.lorri.enable = true;
}
