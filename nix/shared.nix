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
    dhall
    source-han-sans-japanese
    source-han-serif-japanese
    dive
    kanji-stroke-order-font
    docker-compose
    entr
    exa
    mpv
    fd
    fortune
    hack-font
    hexyl
    htop
    jq
    lazygit
    miniserve
    nano
    ncdu
    niv
    nixpkgs-fmt
    pandoc
    ripgrep
    rlwrap
    roboto
    parinfer-rust
    roboto-mono
    rsync
    stow
    tig
    tldr
    tokei
    tree
    universal-ctags
    vim
  ];

in {
  pkgs = sharedPkgs;
}
