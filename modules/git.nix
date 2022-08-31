{ ... }:
{
  programs.git = {
    enable = true;

    ignores = [
      ".direnv"
    ];

    userEmail = "yuuki@protonmail.com";
    userName = "Florian Beeres";

    aliases = {
      r = "branch --sort=-committerdate";
      s = "status";
      a = "add";
      co = "commit";
      ch = "checkout";
      ds = "diff --staged";
      b = "branch";
      cb = "rev-parse --abbrev-ref HEAD";
      dd = "diff";
      pl = "pull";
      ps = "push";
      l = "log";
    };

    lfs = {
      enable = true;
    };

    extraConfig = {
      github.user = "yuuki@protonmail.com";

      init = {
        defaultBranch = "main";
      };

      push = {
        default = "simple";
      };

      diff = {
        algorithm = "histogram";
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
