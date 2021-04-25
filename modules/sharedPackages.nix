{ pkgs, ... }:

with pkgs;

{
  # nixpkgs.overlays = [
  #   (final: prev: {
  #     dash = prev.dash.overrideAttrs (_: {
  #       buildInputs = [ pkgs.libedit ];
  #       configureFlags = [ "--with-libedit" ];
  #     });
  #   })
  # ];

  home.packages = [
    nixpkgs-review

    # Rust CLI replacements
    bat # cat
    du-dust # du
    exa # ls
    fd # find
    # sd # sed
    ripgrep # grep
    # bottom # top

    # aerc
    awscli2
    bashInteractive_5
    coreutils
    curl
    dash
    cmus
    bind
    dhall
    docker-compose
    emacs
    entr
    findutils
    fzf
    gawk
    gh
    gnugrep
    gnused
    gnupg
    jetbrains-mono
    google-cloud-sdk
    gopls
    go
    gzip
    hack-font
    haskellPackages.nix-derivation
    htop
    jq
    kubernetes-helm
    k9s
    libuv
    luajitPackages.luacheck
    liberation_ttf
    nano
    ncdu
    neofetch
    niv
    nixpkgs-fmt
    nodePackages.purescript-language-server
    nodejs
    pandoc
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
    # terraform_0_13
    # termshark
    # wireshark-cli
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
