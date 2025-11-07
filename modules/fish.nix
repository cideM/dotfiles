{
  config,
  inputs,
  ...
}:
let
  fishConfig = ''
    #  alt+e
    bind \cb edit_command_buffer

    set -x BAT_THEME 'GitHub'
    set -x MANPAGER 'nvim +Man!'
    set -x VOLTA_HOME $HOME/.volta

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR is set by pam_systemd and should not be overridden
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache

    set -x GOPATH ~/go
    set -x GOCACHE $XDG_CACHE_HOME/go-build

    fish_add_path -p /usr/local/bin/ $VOLTA_HOME/bin
  '';
in
{
  flake.modules.homeManager.fish =
    { pkgs, lib, ... }:
    {
      programs.fish = {
        enable = true;

        shellAbbrs = {
          g = "git";
          dc = "docker compose";
          n = "nvim";
          k = "kubectl";
        };

        interactiveShellInit =
          fishConfig
          + lib.optionalString pkgs.stdenv.isDarwin ''
            fish_add_path /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/
            fish_add_path /Applications/Sublime\ Merge.app/Contents/SharedSupport/bin/
            fish_add_path /opt/local/bin /opt/local/sbin

            # MacPorts
            if not contains /opt/local/share/man $MANPATH
              set --append MANPATH /opt/local/share/man
            end
          '';

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

          fish_greeting = {
            body = '''';
          };
        };

        plugins = [
          {
            name = "nix-env";
            src = inputs.nix-fish-src;
          }

          {
            name = "yui";
            src = inputs.yui.packages.${pkgs.stdenv.hostPlatform.system}.fish_light.src;
          }

          {
            name = "hydro";
            src = pkgs.fishPlugins.hydro.src;
          }
        ];
      };
    };
}
