{ pkgs, config, ... }:
let
  # These options are set by home manager programs.fzf
  # https://github.com/rycee/home-manager/blob/master/modules/programs/fzf.nix#blob-path
  # It's pointless to use home manager programs.fzf if I'm setting these anyway
  fishConfig = ''
    set -x FZF_DEFAULT_COMMAND '${pkgs.fd}/bin/fd --type f 2> /dev/null'
    set -x FZF_DEFAULT_TOPS '--height 40% --layout=reverse --border'
    set -x FZF_CTRL_T_OPTS "--preview '${pkgs.bat}/bin/bat {}'"
    set -x FZF_ALT_C_OPTS "--preview 'tree -a -C {} | head -200'"
    set -x FZF_CTRL_T_COMMAND '${pkgs.fd}/bin/fd --type f 2> /dev/null'

    # https://github.com/fish-shell/fish-shell/issues/3412
    # https://github.com/fish-shell/fish-shell/issues/5313
    set -u fish_pager_color_prefix 'red' '--underline'

    set -x BAT_THEME "Monokai Extended Light"

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR should be set by pam_systemd
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache

    set -x GOPATH ~/go

    set -x PATH                 \
        ~/bin                   \
        $PATH

    # https://discourse.nixos.org/t/how-is-nix-path-managed-regarding-nix-channel/6079/3?u=cidem
    set -x NIX_PATH ~/.nix-defexpr/channels $NIX_PATH

    abbr -a kubedebug 'kubectl run -i --tty --rm debug --image=radial/busyboxplus:curl --restart=Never -- sh'
    abbr -a g 'git'
    abbr -a dc 'docker-compose'
    abbr -a tf 'terraform'

    alias fzf 'fzf --color=light'
    alias dash 'dash -E'

    source ${pkgs.fzf}/share/fzf/key-bindings.fish && fzf_key_bindings
  '';

in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = fishConfig;

    functions = {
      fish_greeting = {
        body = ''
        '';
      };
    };

    promptInit = ''
      set __fish_git_prompt_show_informative_status 1

      set __fish_git_prompt_char_dirtystate '+'
      set __fish_git_prompt_char_invalidstate 'x'
      set __fish_git_prompt_char_stagedstate '*'
      set __fish_git_prompt_char_untrackedfiles 'u'
      set __fish_git_prompt_char_untrackedfiles 'u'
      set __fish_git_prompt_char_stateseparator '|'

      function fish_prompt
          set_color $fish_color_cwd
          echo -n (basename $PWD)
          fish_git_prompt
          set_color normal
          echo -n ' $ '
      end
    '';

    plugins = [
      {
        name = "nix-env";
        src = config.sources.fish-nix-env;
      }
    ];
  };
}
