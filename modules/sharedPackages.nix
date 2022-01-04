{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    awscli2
    aws-mfa
    # cachix
    # cmus
    dash
    liberation_ttf
    luajitPackages.luacheck
    fastmod
    bashInteractive_5
    bat
    curl
    coreutils
    delta
    git-lfs
    docker-compose
    du-dust
    emacs
    entr
    exa
    fd
    findutils
    fzf
    gawk
    gh
    gnugrep
    gnupg
    gnused
    google-cloud-sdk
    gzip
    hack-font
    htop
    jetbrains-mono
    jq
    kubernetes-helm
    kubectx
    libuv
    ncdu
    kubectl
    nixpkgs-fmt
    nixpkgs-review
    qmk
    rclone
    restic
    ripgrep
    kitty
    rlwrap
    roboto
    roboto-mono
    rsync
    rust-analyzer
    # shellcheck
    time
    tldr
    tokei
    tree
    universal-ctags
    vim
    wget
    yamllint
  ];
}
