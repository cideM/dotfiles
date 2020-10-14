{ pkgs, ... }:
{
  imports = [
    (import ../../modules/alacritty.nix { inherit pkgs; padding = 10; fontSize = 15; decorations = "none"; })
    (import ../../modules/neovim)
    # https://github.com/NixOS/nixpkgs/issues/62353
    # (import ../../modules/git.nix)
    (import ../../modules/tmux)
    (import ../../modules/ctags.nix)
    (import ../../modules/clojure)
    (import ../../modules/pandoc)
    (import ../../modules/fish)
    (import ../../modules/sharedPackages.nix)
    (import ../../modules/sharedSettings.nix)
  ];

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
        rebase = false

    [user]
        email = yuuki@protonmail.com
        name = Florian Beeres

    [alias]
        lola = log --graph --decorate --pretty=oneline --abbrev-commit --all
        recent = branch --sort=-committerdate
        unpushed = log --branches --not --remotes --no-walk --decorate --oneline
        s = status -s
        a = add
        co = commit
        ch = checkout
        b = branch
        cb = rev-parse --abbrev-ref HEAD
        d = diff
        pl = pull
        ps = push

    [difftool]
        prompt = false

    [difftool "nvim"]
        cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'

    [mergetool]
        prompt = true

    [mergetool "nvim-merge"]
        cmd = nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'

    [github]
        user = "yuuki@protonmail.com";

    [core]
        editor = nvim
        ignorecase = false

    [filter "lfs"]
        smudge = git-lfs smudge -- %f
        process = git-lfs filter-process
        required = true
        clean = git-lfs clean -- %f
  '';

  fonts.fontconfig.enable = true;
}
