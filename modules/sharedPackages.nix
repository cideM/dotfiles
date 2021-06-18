{ pkgs, ... }:

with pkgs;

{
  home.packages = [
    awscli2
    bashInteractive_5
    bat
    cachix
    cmus
    coreutils
    curl
    dash
    delta
    git-lfs
    docker-compose
    du-dust
    emacs
    entr
    exa
    fd
    findutils
    fzf
    gawk
    gh
    gnugrep
    gnupg
    gnused
    google-cloud-sdk
    gzip
    hack-font
    htop
    jetbrains-mono
    jq
    k9s
    kubernetes-helm
    liberation_ttf
    libuv
    luajitPackages.luacheck
    ncdu
    kubectl
    niv
    nixpkgs-fmt
    nixpkgs-review
    pandoc
    qmk
    ranger
    rclone
    restic
    ripgrep
    rlwrap
    roboto
    roboto-mono
    rsync
    rust-analyzer
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
    # Darwin
    # builder for '/nix/store/0va6zhfzh6x2didrlijivh5xkw7zws0i-weechat-3.2.drv' failed with exit code 2; last 10 log lines:
    # /tmp/nix-build-weechat-3.2.drv-0/weechat-3.2/src/core/wee-dir.c:648:24: error: implicit declaration of function 'mkdtemp' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
    #   ptr_weechat_home = mkdtemp (temp_home_template);
    #                      ^
    # /tmp/nix-build-weechat-3.2.drv-0/weechat-3.2/src/core/wee-dir.c:648:22: warning: incompatible integer to pointer conversion assigning to 'char *' from 'int' [-Wint-conversion]
    #   ptr_weechat_home = mkdtemp (temp_home_template);
    #                    ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    # weechat
    wget
    yamllint
  ];
}
