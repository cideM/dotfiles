{ pkgs, ... }:

with pkgs;

{
  nixpkgs.overlays = [
    (final: prev: {
      dash = prev.dash.overrideAttrs (_: {
        buildInputs = [ pkgs.libedit ];
        configureFlags = [ "--with-libedit" ];
      });
    })
  ];

  home.packages = [

    # Rust CLI replacements
    bat # cat
    du-dust # du
    exa # ls
    fd # find
    sd # sed
    ripgrep # grep
    bottom # top

    aerc
    awscli
    bash_5
    bandwhich
    coreutils
    curl
    dash
    bind
    dhall
    dhall-lsp-server
    dive
    docker-compose
    emacs
    entr
    findutils
    fzf
    gawk
    gitAndTools.hub
    gnugrep
    gnupg
    golangci-lint
    google-cloud-sdk
    gopls
    graphviz
    gzip
    hack-font
    haskellPackages.brittany
    haskellPackages.nix-derivation
    hexyl
    htop
    hyperfine
    jq
    jrnl
    kubernetes-helm
    lazygit
    libuv
    luajitPackages.luacheck
    nano
    ncdu
    neofetch
    niv
    nixpkgs-fmt
    nodePackages_latest.purescript-language-server
    pandoc
    perl
    # https://github.com/NixOS/nixpkgs/issues/96921
    # qmk_firmware
    ranger
    rclone
    restic
    rlwrap
    roboto
    roboto-mono
    rsync
    rust-analyzer
    s3cmd
    shellcheck
    shfmt
    stow
    terraform_0_13
    tig
    time
    tldr
    tokei
    tree
    universal-ctags
    vim
    weechat
    wget
    yamllint

  ];
}
