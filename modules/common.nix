{pkgs, ...}:
with pkgs; {
  home.packages = [
    bashInteractive
    bat
    btop
    coreutils-full
    curl
    diffoci
    du-dust
    dua
    entr
    fastmod
    fd
    findutils
    gawk
    gh
    git-lfs
    github-markdown-toc
    glow
    gnugrep
    gnupg
    gnused
    gzip
    haskellPackages.hledger_1_41
    helix
    htop
    hyperfine
    jq
    micro
    monaspace
    nano
    nixpkgs-review
    oils-for-unix
    rclone
    ripgrep
    rlwrap
    shellcheck
    time
    tokei
    tree
    uni
    universal-ctags
    unzip
    vis
    wget
  ];

  nix = {
    gc = {
      automatic = true;
      frequency = "daily";
    };
  };

  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "en_US.UTF-8";
    VISUAL = "nvim";
    EDITOR = "nvim";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";
    changeDirWidgetOptions = [
      "--preview '${pkgs.eza}/bin/eza --oneline --git --long {}'"
      "--color=light"
    ];
    historyWidgetOptions = [
      "--sort"
    ];
    fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
    fileWidgetOptions = [
      "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers --line-range :300 {}'"
      "--color=light"
    ];
    defaultCommand = "fd --type f --hidden --follow --exclude .git";
    defaultOptions = [
      "--color=light"
    ];
  };

  programs.dircolors = {
    enable = true;
    enableFishIntegration = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  programs.man.enable = true;

  xdg.configFile.".gemrc".text = ''
    :ipv4_fallback_enabled: true
  '';

  home.file = {
    ".gitignore" = {
      text = ''
        .direnv
      '';
    };

    "/Library/Preferences/glow/glow.yml" = {
      text = ''
        # style name or JSON path (default "auto")
        style: "auto"
        # show local files only; no network (TUI-mode only)
        local: true
        # mouse support (TUI-mode only)
        mouse: false
        # use pager to display markdown
        pager: false
        # word-wrap at width
        width: 80
      '';
    };
  };

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = ["info" "man" "share" "icons" "doc"];

  xdg.configFile."git/attributes".text = ''
    *.lockb binary diff=lockb
  '';

  xdg.configFile."nix/registry.json".text = builtins.toJSON {
    version = 2;
    flakes = {
      fbrs = {
        from = {
          id = "fbrs";
          type = "indirect";
        };
        to = {
          type = "github";
          owner = "cidem";
          repo = "nix-templates";
        };
      };
    };
  };
}
