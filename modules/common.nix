{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    bat
    exa
    ripgrep
    fd
    gh
    git-lfs
    delta
    bashInteractive
    coreutils-full
    curl
    du-dust
    entr
    fastmod
    findutils
    fzf
    gawk
    gnugrep
    gnupg
    gnused
    gzip
    htop
    jq
    ncdu
    rclone
    restic
    rlwrap
    rsync
    time
    tokei
    tree
    universal-ctags
    vim
    wget
    unzip
    hyperfine
    shellcheck
  ];

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    VISUAL = "nvim";
    EDITOR = "nvim";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];
}

