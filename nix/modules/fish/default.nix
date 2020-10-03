{ pkgs, ... }:
let
  sources = import ./nix/sources.nix;

  # These options are set by home manager programs.fzf
  # https://github.com/rycee/home-manager/blob/master/modules/programs/fzf.nix#blob-path
  # It's pointless to use home manager programs.fzf if I'm setting these anyway
  fishConfig = ''
    set -x FZF_DEFAULT_COMMAND '${pkgs.fd}/bin/fd --type f 2> /dev/null'
    set -x FZF_DEFAULT_TOPS '--height 40% --layout=reverse --border'
    set -x FZF_CTRL_T_OPTS "--preview '${pkgs.bat}/bin/bat {}'"
    set -x FZF_ALT_C_OPTS "--preview 'tree -a -C {} | head -200'"
    set -x FZF_CTRL_T_COMMAND '${pkgs.fd}/bin/fd -L $dir --type f 2> /dev/null'

    # https://github.com/fish-shell/fish-shell/issues/3412
    # https://github.com/fish-shell/fish-shell/issues/5313
    set -u fish_pager_color_prefix 'red' '--underline'

    set -x BAT_THEME "Monokai Extended Light"

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR should be set by pam_systemd
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache

    set -x PATH                 \
        ~/.local/bin            \
        ~/bin                   \
        ~/.emacs.d/bin          \
        $PATH

    set -x NIX_PATH ~/.nix-defexpr/channels $NIX_PATH

    abbr -a pbc 'xclip -selection clipboard'
    abbr -a gotest 'fd -e go | entr -rc go test ./...'
    abbr -a gocheck 'fd -e go | entr -rc go build ./...'
    abbr -a g 'git'
    abbr -a n "nvim (notes search)/body*"
    abbr -a todo 'nvim $FISH_NOTES_DIR/916797/body.md'
    abbr -a ideas 'nvim $FISH_NOTES_DIR/785479/body.md'
    abbr -a kubedebug 'kubectl run -i --tty --rm debug --image=ubuntu --restart=Never -- bash'
    alias fzf 'fzf --color=light'
    alias ls exa
    alias dash 'dash -E'

    source ${pkgs.fzf}/share/fzf/key-bindings.fish && fzf_key_bindings

    # opam configuration
    if test -d /home/tifa/.opam/opam-init/init.fish 
        source /home/tifa/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true
    end

    # Source hostname specific stuff
    set -l hostname_file $XDG_CONFIG_HOME/fish/(hostname).fish
    if test -e $hostname_file
        source $hostname_file
    end
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
        name = "journal";
        src = sources.fish-journal;
      }

      {
        name = "nix-env";
        src = sources.fish-nix-env;
      }

      {
        name = "fish-notes";
        src = sources.fish-notes;
      }
    ];
  };
}
