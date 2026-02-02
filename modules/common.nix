{ inputs, ... }:
{
  flake.modules.homeManager.common =
    { pkgs, lib, ... }:
    let
      github-markdown-toc = pkgs.buildGoModule {
        name = "github-markdown-toc-go";
        version = "latest";
        src = inputs.github-markdown-toc-go-src;
        vendorHash = "sha256-K5yb7bnW6eS5UESK9wgNEUwGjB63eJk6+B0jFFiFero=";
      };

    in
    {
      home.packages = with pkgs; [
        age
        bashInteractive
        bat
        btop
        claude-code
        coreutils-full
        curl
        diffoci
        dua
        dust
        entr
        eza
        fastmod
        fd
        findutils
        gawk
        gemini-cli
        gh-markdown-preview
        github-markdown-toc
        gnugrep
        gnupg
        gnused
        gzip
        helix
        hledger
        hyperfine
        jrnl
        jq
        lua
        micro
        moreutils
        nh
        nodePackages.prettier
        nodejs
        nix-output-monitor
        oils-for-unix
        pandoc
        rclone
        ripgrep
        rlwrap
        rsync
        shellcheck
        sops
        ssh-to-age
        tasksh
        time
        timewarrior
        tokei
        tree
        uni
        universal-ctags
        unixtools.watch
        unzip
        wget
      ];

      xdg.configFile."jrnl/jrnl.yaml".source = (pkgs.formats.yaml { }).generate "" {
        colors = {
          body = "NONE";
          date = "NONE";
          tags = "NONE";
          title = "NONE";
        };
        default_hour = 9;
        default_minute = 0;
        editor = "nvim";
        encrypt = true;
        highlight = true;
        indent_character = "|";
        journals = {
          default = "/Users/fbs/private/journal/journal.txt";
        };
        linewrap = "auto";
        tagsymbols = "#@";
        template = false;
        timeformat = "%F %r";
        version = "v${pkgs.jrnl.version}";
      };

      programs.taskwarrior = {
        package = pkgs.taskwarrior3;
        enable = true;
        colorTheme = "no-color";
        config = {
          news.version = "3.4.2";
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
          dates = "daily";
        };
        # package = pkgs.lixPackageSets.stable.lix;
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
        jujutsu.enable = true;
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

      xdg.dataFile."task/hooks/on-modify.timewarrior" = {
        executable = true;
        source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
      };

      xdg.configFile = {
        ".gemrc".text = ''
          :ipv4_fallback_enabled: true
        '';
      };

      # https://github.com/rycee/home-manager/issues/432
      programs.man.enable = false;
      home.extraOutputsToInstall = [
        "man"
      ];

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

      xdg.configFile."ctags/1.ctags".text = ''
        --exclude=compiled
        --exclude=build
        --exclude=min
        --exclude=vendor
        --exclude=*.min.*
        --exclude=*.map
        --exclude=*.swp
        --exclude=*.bak
        --exclude=tags
        --exclude=dist
        --exclude=*.json
      '';

      xdg.configFile."ctags/javascript.ctags".text = ''
        --exclude=node_modules
        --exclude=project.json
        --exclude=package-lock.json
        --exclude=yarn.lock
      '';

      xdg.configFile."ctags/go.ctags".text = ''
        --exclude=go.mod
        --exclude=go.sum
      '';

      xdg.configFile."ctags/rust.ctags".text = ''
        --exclude=target
      '';

      fonts.fontconfig.enable = true;
    };
}
