{ pkgs, ... }:
with pkgs;
{
  home.packages = [
    age
    bashInteractive
    bat
    btop
    claude-code
    coreutils-full
    curl
    diffoci
    dust
    dua
    entr
    eza
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
    helix
    hledger
    htop
    hyperfine
    jq
    micro
    moreutils
    nano
    nix-output-monitor
    nh
    oils-for-unix
    rclone
    ripgrep
    rlwrap
    rsync
    shellcheck
    tasksh
    time
    timewarrior
    sops
    ssh-to-age
    tokei
    tree
    uni
    universal-ctags
    unzip
    wget
  ];

  programs.taskwarrior = {
    package = pkgs.taskwarrior3;
    enable = true;
    colorTheme = "no-color";
    config = {
      news.version = "3.3.0";
      context = {
        work = {
          read = "+work";
          write = "+work";
        };
        home = {
          read = "-work +home";
          write = "+home";
        };
      };
    };
  };

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
    PAGER = "less -FirSwX";
    EDITOR = "nvim";
    SHELL = "${pkgs.fish}/bin/fish";
  };

  programs = {
    dircolors = {
      enable = true;
      enableFishIntegration = true;
    };
    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
      };
    };
    man.enable = true;
    fzf = {
      enable = true;
      enableFishIntegration = true;
      changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git .";
      changeDirWidgetOptions = [
        "--preview '${pkgs.eza}/bin/eza --oneline --color=never --git --long {}'"
        "--style=minimal"
      ];
      historyWidgetOptions = [
        "--sort"
      ];
      fileWidgetCommand = "fd --type f --hidden --follow --exclude .git . \\$dir";
      fileWidgetOptions = [
        "--preview '${pkgs.bat}/bin/bat --color=always --style=numbers --line-range :300 {}'"
        "--style=minimal"
      ];
      defaultCommand = "fd --type f --hidden --follow --exclude .git .";
      defaultOptions = [
        "--style=minimal"
      ];
    };
  };

  programs.man.enable = true;

  xdg.dataFile."task/hooks/on-modify.timewarrior" = {
    executable = true;
    source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
  };

  xdg.configFile.".gemrc".text = ''
    :ipv4_fallback_enabled: true
  '';

  home.file = {
    ".gitignore" = {
      text = ''
        .direnv
        .devenv
      '';
    };
  };

  # https://github.com/rycee/home-manager/issues/432
  home.extraOutputsToInstall = [
    "info"
    "man"
    "share"
    "icons"
    "doc"
  ];

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
