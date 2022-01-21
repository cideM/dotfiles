{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    # Unix Rust Replacements
    bat
    exa
    ripgrep
    fd

    # Version control
    gh
    git-lfs
    delta

    # Misc
    bashInteractive
    coreutils-full
    curl
    dash
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
    kitty
    libuv
    ncdu
    qmk
    rclone
    restic
    rlwrap
    rsync
    time
    tldr
    tokei
    tree
    universal-ctags
    vim
    wget

    # Infrastructure
    awscli2
    aws-mfa
    docker-compose
    google-cloud-sdk
    kubectl
    kubernetes-helm

    # Language stuff
    luajitPackages.luacheck
    nixpkgs-fmt
    nixpkgs-review
    rust-analyzer
    shellcheck
    yamllint

    # Fonts
    liberation_ttf
    hack-font
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

