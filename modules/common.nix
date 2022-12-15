{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    alejandra
    delta
    bashInteractive
    bat
    coreutils-full
    curl
    du-dust
    anki-bin
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
    tldr
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
    sumneko-lua-language-server
    time
    tokei
    tree
    universal-ctags
    unzip
    vim
    volta
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

