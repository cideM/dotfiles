{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    bashInteractive
    bat
    coreutils-full
    curl
    du-dust
    entr
    exa
    fastmod
    fd
    findutils
    fzf
    gawk
    gh
    git-lfs
    gnugrep
    gnupg
    gnused
    gzip
    helix
    htop
    hyperfine
    jq
    kubectl
    luajitPackages.luacheck
    ncdu
    nixpkgs-fmt
    nixpkgs-review
    nodePackages.vscode-langservers-extracted
    rclone
    restic
    ripgrep
    rlwrap
    rsync
    shellcheck
    stylua
    time
    tokei
    tree
    universal-ctags
    unzip
    vim
    wget
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

