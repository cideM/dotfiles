{ pkgs, ... }:
{
  imports = [
    (import ../../modules/alacritty.nix)
    (import ../../modules/neovim)
    # https://github.com/NixOS/nixpkgs/issues/62353
    # (import ../../modules/git.nix)
    (import ../../modules/tmux)
    (import ../../modules/ctags.nix)
    (import ../../modules/sources.nix)
    (import ../../modules/pandoc)
    (import ../../modules/fish)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedSettings.nix)
  ];

  sources = import ../../nix/sources.nix;

  programs.fish.interactiveShellInit = ''
    set -x FISH_NOTES_DIR ~/.local/share/fish_notes
    set -x FISH_JOURNAL_DIR ~/.local/share/fish_journal

    contains ${pkgs.coreutils}/bin $PATH
    or set -x PATH ${pkgs.coreutils}/bin $PATH/
  '';

  home.packages = with pkgs; [ lorri unixtools.watch ];

  # Install through casks for Alacritty.app etc
  programs.alacritty.enable = false;

  # Can't use programs.git because https://github.com/NixOS/nixpkgs/issues/62353
  xdg.configFile."git/config".text = ''
    [push]
        default = simple

    [pull]
        rebase = true

    [user]
        email = yuuki@protonmail.com
        name = Florian Beeres

    [github]
        user = "yuuki@protonmail.com";

    [core]
        editor = nvim

    [filter "lfs"]
        clean = git-lfs clean -- %f
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true
  '';

  fonts.fontconfig.enable = true;

  programs.tmux.extraConfig = ''
    bind-key -T copy-mode-vi y send -X copy-pipe-and-cancel "pbcopy"
  '';
}
