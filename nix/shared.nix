let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      # (import ./programs/anki/overlay.nix)
    ];
  };

  sharedPkgs = with pkgs; [
    awscli
    bash
    bat
    coreutils
    curl
    dhall
    dive
    docker-compose
    entr
    exa
    fd
    findutils
    fortune
    gawk
    gitAndTools.delta
    gitAndTools.hub
    gnugrep
    gnupg
    gzip
    hack-font
    hexyl
    htop
    jq
    jrnl
    kanji-stroke-order-font
    kubernetes-helm
    lazygit
    libuv
    miniserve
    mpv
    nano
    ncdu
    neofetch
    niv
    nixpkgs-fmt
    pandoc
    parinfer-rust
    perl
    rclone
    restic
    ripgrep
    rlwrap
    roboto
    roboto-mono
    rsync
    rust-analyzer
    s3cmd
    shfmt
    source-han-sans-japanese
    source-han-serif-japanese
    stow
    tig
    tldr
    tokei
    tree
    universal-ctags
    vim
    weechat
    wget
    yamllint
  ];

in {
  pkgs = sharedPkgs;
}
