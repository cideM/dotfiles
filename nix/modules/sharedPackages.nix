{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    aerc
    awscli
    bash_5

    # Rust CLI replacements
    bat     # cat
    du-dust # du
    exa     # ls
    fd      # find
    sd      # sed
    ripgrep # grep
    ytop    # top

    bandwhich
    coreutils
    curl
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
    graphviz
    gnupg
    golangci-lint
    google-cloud-sdk
    gopls
    gzip
    hack-font
    haskellPackages.brittany
    hexyl
    haskellPackages.nix-derivation
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
