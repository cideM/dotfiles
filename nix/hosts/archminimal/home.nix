{ pkgs, config, ... }:
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
  ];

  home.packages = with pkgs; [ slack ];

  programs.fish.shellInit = ''
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  # https://github.com/rycee/home-manager/blob/master/modules/targets/generic-linux.nix#blob-path
  targets.genericLinux.enable = true;

  services.lorri.enable = true;

  programs.alacritty.enable = false;

  xdg.mime.enable = true;

}
