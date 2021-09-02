{ pkgs
, config
, scripts
, cidem-fish-notes
, cidem-fish-yvm
, nix-env-fish
, lucid-fish-prompt
, ...
}:
let
  alacCfg = config.programs.alacritty;

  # These options are set by home manager programs.fzf
  # https://github.com/rycee/home-manager/blob/master/modules/programs/fzf.nix#blob-path
  # It's pointless to use home manager programs.fzf if I'm setting these anyway
  fishConfig = ''
    set -x FZF_DEFAULT_COMMAND '${pkgs.fd}/bin/fd --type f 2> /dev/null'
    set -x FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --no-color'
    set -x FZF_CTRL_T_OPTS "--preview '${pkgs.bat}/bin/bat {}'"
    set -x FZF_ALT_C_OPTS "--preview 'tree -a -C {} | head -200'"
    set -x FZF_CTRL_T_COMMAND '${pkgs.fd}/bin/fd -L $dir --type f 2> /dev/null'

    set -x FISH_NOTES_EXTENSION .md
    set -x MANPAGER 'nvim +Man!'

    # The ❯ looks super weird on my linux machine
    set -x lucid_prompt_symbol '$'

    # COLORS
    # https://github.com/fish-shell/fish-shell/issues/4695
    # https://fishshell.com/docs/2.0/index.html
    # $ set | rg color
    # $ set_color -c
    # $ nix-shell -p gettext
    # $ msgcat --color=test

    # Background of tab completion and matched part in history
    set fish_color_search_match --background=yellow

    set fish_pager_color_prefix normal --bold
    set fish_pager_color_description normal
    set fish_pager_color_progress normal

    # https://github.com/fish-shell/fish-shell/issues/5527
    set fish_color_match normal --underline

    set fish_color_comment --italics
    set fish_color_command magenta
    set fish_color_quote green
    set fish_color_error red --bold

    ${if alacCfg.light then ''
      set fish_color_cwd brblack
      # telescope vim is bit buggy and will call bat with `bat --theme Monokai
      # Extended Light` which obviously doesn't work
      set -x BAT_THEME "OneHalfLight"
    '' else ''
      set fish_color_cwd white
    ''}

    # https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
    # XDG_RUNTIME_DIR should be set by pam_systemd
    set -x XDG_CONFIG_HOME $HOME/.config
    set -x XDG_DATA_HOME $HOME/.local/share
    set -x XDG_CACHE_HOME $HOME/.cache

    set -x GOPATH ~/go

    set -x PATH                 \
        ~/bin                   \
        ${scripts}              \
        $PATH

    # https://discourse.nixos.org/t/how-is-nix-path-managed-regarding-nix-channel/6079/3?u=cidem
    set -x NIX_PATH ~/.nix-defexpr/channels $NIX_PATH

    abbr -a kubedebug 'kubectl run -i --tty --rm debug --image=radial/busyboxplus:curl --restart=Never -- sh'
    abbr -a g 'git'
    abbr -a dc ${if pkgs.stdenv.isDarwin then "'docker compose'" else "'docker-compose'"}
    abbr -a gap 'git add --patch'
    abbr -a tf 'terraform'
    abbr -a wn 'FISH_NOTES_DIR=$FISH_WORK_NOTES n'
    abbr -a work-agenda 'FISH_NOTES_DIR=$FISH_WORK_NOTES agenda'
    abbr -a work-new-agenda 'FISH_NOTES_DIR=$FISH_WORK_NOTES new-agenda'
    abbr -a work-notes 'FISH_NOTES_DIR=$FISH_WORK_NOTES notes'
    abbr -a klabels 'sed \'1d\' | awk \'{ print $6 }\' | string split ","'
    abbr -a work-todos 'FISH_NOTES_DIR=$FISH_WORK_NOTES todos'

    alias  niv 'niv --no-colors'
    alias dash 'dash -E'

    source ${pkgs.fzf}/share/fzf/key-bindings.fish && fzf_key_bindings
  '';

in
{
  programs.fish = {
    enable = true;

    interactiveShellInit = fishConfig;

    functions = {
      gocheck = {
        description = "Recompile on change";
        body = ''
          set exist
          for dir in "cmd" "internal" "pkg"
            if test -d $dir
                set -a exist ./$dir/...
            end
          end
          ${pkgs.fd}/bin/fd -e go | ${pkgs.entr}/bin/entr -sc "go build $exist"
        '';
      };

      gi = {
        description = "Pick commit for interactive rebase";
        body = ''
          set -l commit (git log --pretty=oneline | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
          if test -n "$commit"
            git rebase $commit~1 --interactive --autosquash
          end
        '';
      };

      gf = {
        description = "Fixup a commit then autosquash";
        body = ''
          set -l commit (git log --pretty=oneline | fzf --preview 'git show (echo {} | awk \'{ print $1 }\')' | awk '{ print $1 }')
          if test -n "$commit"
            git commit --fixup $commit
            GIT_SEQUENCE_EDITOR=true git rebase $commit~1 --interactive --autosquash
          end
        '';
      };

      gu = {
        description = "Update master and rebase current branch onto master";
        body = ''
          set -l default (git symbolic-ref refs/remotes/origin/HEAD | xargs basename)
          if test -n "$default"
            git fetch origin $default:$default
            git rebase $default
          end
        '';
      };

      gc = {
        description = "fzf git checkout";
        body = ''
          git ch (git b -a --sort=-committerdate | 
            fzf --preview 'git log (echo {} | sed -E -e \'s/^(\+|\*)//\' | string trim) -- ' | 
            sed -E -e 's/^(\+|\*)//' | 
            xargs basename | 
            string trim)
        '';
      };

      findnote = {
        description = "Find a note interactively with ripgrep and FZF";
        body = ''
          # 1. Pipe all lines with ripgrep into fzf
          # 2. Preview only the body (use local variable to suppress wildcard expansion errors)
          # 3. Result will be path/to/file:with:colons:matched term -> split it and keep only the file part (colons come from ISO8601 date)
          # 4. Echo the directory name
          set -l note (rg '.*' $FISH_NOTES_DIR | fzf --preview 'set -l n (dirname {1..4}); cat $n/title*; echo "---------"; cat $n/body*' --delimiter ':' --with-nth '2..')

          if test -n "$note"
            echo $note | string split ':' | head -n 4 | string join ":" | xargs dirname
          end
        '';
      };

      n = {
        description = "Wrapper around findnote to open it in $EDITOR";
        body = ''
          set -l fp (findnote)

          if test -n "$fp"
            $EDITOR $fp/body*
          end
        '';
      };

      agenda = {
        description = "Open agenda for today";
        body = ''
          set -l today (date -I)
          set -l agenda_file (rg agenda $FISH_NOTES_DIR/$today*/tags -l)
          set -l agenda_num (count $agenda_file)

          if test $agenda_num -gt 1
            echo "Found more than one agenda file"
            for f in $agenda_file; echo $f; end
            return 1
          end

          if test $agenda_num -eq 0
            echo "No agenda found"
            return 1
          end

          nvim (dirname $agenda_file)/body*
        '';
      };

      new-agenda = {
        description = "Create new agenda for today";
        body = ''
          set -l agenda_date (date -I)
          # This stores my TODOs formatted in a nicer way in the template
          # variable, which equals the buffer contents when $EDITOR opens.
          # Only downside is that if you make 0 edits the note won't be saved
          # because you didn't change the template.
          __notes_entry_template=(todos | string collect) notes new -T "Agenda: $agenda_date" -t agenda
        '';
      };

      todos = {
        description = ''
          Gather all TODOs from my notes and format them in a way
          that is easy to turn into an agenda
        '';
        body = ''
          set -l agenda_date (date -I)

          echo "# Agenda: $agenda_date"
          echo ""

          set -l todos (rg 'TODO:' $FISH_NOTES_DIR -l)

          if test (count $todos) -eq 0
            echo "No TODOs, hooray!"
            return 0
          end

          for f in $todos
            set -l title (cat (dirname $f)/title)

            if test -n "$title"
              printf "## [%s](%s)\n" $title $f
            else
              printf "## %s\n" $f
            end

            rg 'TODO:' $f | sed 's/TODO:/- [ ]/'
            echo ""
          end
        '';
      };

      fish_greeting = {
        body = ''
        '';
      };
    };

    plugins = [
      {
        name = "fish-notes";
        src = cidem-fish-notes;
      }

      {
        name = "nix-env";
        src = nix-env-fish;
      }

      {
        name = "lucid";
        src = lucid-fish-prompt;
      }

      {
        name = "fish-yvm";
        src = cidem-fish-yvm;
      }
    ];
  };
}
