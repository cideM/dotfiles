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
    # bandwhich

    # aerc
    awscli2
    bashInteractive_5
    coreutils
    curl
    dash
    bind
    dhall
    dhall-lsp-server
    dive
    docker-compose
    # emacs
    entr
    findutils
    fzf
    gawk
    gitAndTools.hub
    gnugrep
    gnupg
    golangci-lint
    google-cloud-sdk
    # haskell-language-server
    gopls
    gzip
    hack-font
    haskellPackages.nix-derivation
    # hexyl
    htop
    # hyperfine
    jq
    jrnl
    kubernetes-helm
    # lazygit
    libuv
    # luajitPackages.luacheck
    liberation_ttf
    nano
    ncdu
    neofetch
    niv
    # nvi
    nixpkgs-fmt
    nodePackages.purescript-language-server
    nodejs
    pandoc
    # perl
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
    # stow
    terraform_0_13
    # termshark
    # wireshark-cli
    tig
    time
    tldr
    tokei
    tree
    universal-ctags
    vim
    # weechat
    wget
    yamllint

  ];
}
