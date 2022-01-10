{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    awscli2
    aws-mfa
    dash
    luajitPackages.luacheck
    fastmod
    bashInteractive
    bat
    curl
    coreutils
    delta
    git-lfs
    docker-compose
    du-dust
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
    htop
    jq
    kubernetes-helm
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
    rsync
    rust-analyzer
    shellcheck
    time
    tldr
    tokei
    tree
    universal-ctags
    vim
    wget
    yamllint
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
  programs.direnv.enableFishIntegration = true;
  programs.direnv.nix-direnv.enable = true;

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = [ "info" "man" "share" "icons" "doc" ];
}

