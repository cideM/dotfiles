let
  sources = import ./nix/sources.nix;

  pkgs = import sources.nixpkgs {
    overlays = [
      # (import ./programs/anki/overlay.nix)
    ];
  };

  sharedPkgs = with pkgs; [
    awscli
    bat
    coreutils
    curl
    dhall
    neofetch
    jrnl
    gitAndTools.delta
    dive
    docker-compose
    entr
    exa
    fd
    fortune
    gawk
    gnugrep
    hack-font
    hexyl
    htop
    jq
    kanji-stroke-order-font
    lazygit
    libuv
    miniserve
    mpv
    nano
    ncdu
    findutils
    niv
    nixpkgs-fmt
    pandoc
    parinfer-rust
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
    perl
    weechat
    gzip
    gitAndTools.hub
    wget
  ];

in {
  pkgs = sharedPkgs;
}
