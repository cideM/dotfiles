{
  pkgs,
  config,
  ...
}: let
  fishConfig = ''
    bind \cb edit_command_buffer

    set -x BAT_THEME 'GitHub'

    set -x MANPAGER 'nvim +Man!'

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR should be set by pam_systemd
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache
    set -x XDG_RUNTIME_DIR $HOME/.runtime
    mkdir -p $XDG_RUNTIME_DIR

    fish_add_path /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/
    fish_add_path /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/

    set -x GOPATH ~/go
    set -x GOCACHE $XDG_CACHE_HOME/go-build

    fish_add_path -p ~/bin /usr/local/bin/
  '';
in {
  programs.fish = {
    enable = true;

    shellAbbrs = {
      g = "git";
      dc = "docker compose";
      tf = "terraform";
      n = "nvim";
      k = "kubectl";
    };

    interactiveShellInit = fishConfig;

    functions = {
      gi = {
        description = "Pick commit for interactive rebase";
        body = ''
          set -l commit (git log --oneline --decorate | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
          if test -n "$commit"
            git rebase $commit~1 --interactive --autosquash
          end
        '';
      };

      gf = {
        description = "Fixup a commit then autosquash";
        body = ''
          set -l commit (git log --oneline --decorate | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
          if test -n "$commit"
            git commit --fixup $commit
            GIT_SEQUENCE_EDITOR=true git rebase $commit~1 --interactive --autosquash
          end
        '';
      };

      gc = {
        description = "fzf git checkout";
        body = ''
          git checkout (git branch -a --sort=-committerdate |
            fzf --preview 'git log (echo {} | sed -E -e \'s/^(\+|\*)//\' | string trim) -- ' |
            sed -E -e 's/^(\+|\*)//' |
            xargs basename |
            string trim)
        '';
      };

      fish_greeting = {
        body = ''
        '';
      };
    };

    plugins = [
      {
        name = "nix-env";
        src = pkgs.nix-fish.src;
      }

      {
        name = "yui";
        src = pkgs.fishPlugins.yui.src;
      }

      {
        name = "lucid";
        src = pkgs.lucid-fish-prompt.src;
      }
    ];
  };
}
