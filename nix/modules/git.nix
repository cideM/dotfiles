{ pkgs, ... }:
{
  programs.git = {
    enable = true;

    userEmail = "yuuki@protonmail.com";
    userName = "Florian Beeres";

    aliases = {
      lola = "log --graph --decorate --pretty=oneline --abbrev-commit --all";
      recent = "branch --sort=-committerdate";
      unpushed = "log --branches --not --remotes --no-walk --decorate --oneline";
      s = "status -s";
      a = "add";
      co = "commit";
      ch = "checkout";
      b = "branch";
      cb = "rev-parse --abbrev-ref HEAD";
      d = "diff";
      pl = "pull";
      ps = "push";
    };

    lfs = {
      enable = true;
    };

    extraConfig = {
      github.user = "yuuki@protonmail.com";

      push = {
        default = "simple";
      };

      pull = {
        rebase = false;
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
