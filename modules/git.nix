{pkgs, ...}: {
  programs.git = {
    enable = true;

    ignores = [
      ".direnv"
    ];

    userEmail = "yuuki@protonmail.com";
    userName = "Florian Beeres";

    lfs = {
      enable = true;
    };

    extraConfig = {
      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com";
        };
      };

      github.user = "yuuki@protonmail.com";

      init = {
        defaultBranch = "main";
      };

      push = {
        default = "simple";
      };

      diff = {
        algorithm = "histogram";
        lockb = {
          textconv = "${pkgs.bun}/bin/bun";
          binary = true;
        };
      };

      pull = {
        rebase = true;
      };

      diff = {
        colorMoved = "default";
      };

      difftool = {
        prompt = false;
      };

      "difftool \"nvim\"" = {
        cmd = "nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
      };

      merge = {
        conflictStyle = "diff3";
      };

      "mergetool \"nvim-merge\"" = {
        cmd = "nvim -d $BASE $LOCAL $REMOTE $MERGED -c '$wincmd w' -c 'wincmd J'";
      };

      mergetool = {
        prompt = true;
      };

      core = {
        editor = "nvim";
        ignorecase = false;
      };
    };
  };
}
