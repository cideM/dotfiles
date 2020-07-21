set -x FZF_DEFAULT_COMMAND 'fd --type f 2> /dev/null'
set -x FZF_PREVIEW_FILE_CMD 'bat'
set -x FZF_ENABLE_OPEN_PREVIEW 1
set -x FZF_FIND_FILE_COMMAND 'fd --type f --type d --hidden 2> /dev/null'
set -x FZF_CD_COMMAND 'fd --type d 2> /dev/null'
set -x FZF_CD_WITH_HIDDEN_COMMAND 'fd --type d --hidden 2> /dev/null'
set -x FZF_LEGACY_KEYBINDINGS 0

# https://github.com/fish-shell/fish-shell/issues/3412
# https://github.com/fish-shell/fish-shell/issues/5313
set -u fish_pager_color_prefix 'red' '--underline'

set -x BAT_THEME "Monokai Extended Light"

set -x LANG en_US.UTF-8
set -x LC_ALL en_US.UTF-8
set -x LC_CTYPE en_US.UTF-8

set -x GO111MODULE on

set -x VISUAL nvim
set -x EDITOR nvim

# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html
# XDG_RUNTIME_DIR should be set by pam_systemd
set -x XDG_CONFIG_HOME $HOME/.config
set -x XDG_DATA_HOME $HOME/.local/share
set -x XDG_CACHE_HOME $HOME/.cache

# Prepend common $PATH segments to $PATH but only if they're not already included in $PATH
set -x PATH                 \
    ~/.local/bin            \
    ~/bin                   \
    ~/.cargo/bin            \
    ~/go/bin               \
    ~/.yarn/bin             \
    ~/.emacs.d/bin          \
    $PATH

set -x NIX_PATH ~/.nix-defexpr/channels $NIX_PATH

abbr -a pbc 'xclip -selection clipboard'
abbr -a g 'git'
abbr -a todo 'rg --heading "\s*\* TODO" $NOTES_DIR | string trim'
abbr -a maybe 'rg --heading "\s*\* MAYBE" $NOTES_DIR | string trim'
abbr -a inprogress 'rg --heading "\s*\* IN PROGRESS" $NOTES_DIR | string trim'
abbr -a devdiary 'set FISH_JOURNAL_DIR ~/work/devdiary; journal'
abbr -a ovr 'exa -la --tree --git-ignore --git -I ".git"'
abbr -a note 'nvim $NOTES_DIR/'
alias ls exa
alias fzf 'fzf --color=light'

# opam configuration
if test -d /home/tifa/.opam/opam-init/init.fish 
    source /home/tifa/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true
end

switch (hostname)
    case archminimal
        set -x FISH_NOTES_DIR /data/fish_notes
        set -x FISH_JOURNAL_DIR /data/fish_journal
        set -x SHELL /usr/bin/fish
    case archdesktop
        set -x FISH_NOTES_DIR /data/fish_notes
        set -x FISH_JOURNAL_DIR /data/fish_journal
        set -x SHELL /usr/bin/fish
    case fbs-work.local
        set -x FISH_NOTES_DIR $XDG_DATA_HOME/fish_notes
        set -x FISH_JOURNAL_DIR $XDG_DATA_HOME/fish_journal
        set -x SHELL (which fish)

        contains /usr/local/opt/coreutils/libexec/gnubin $PATH
        or set -x PATH /usr/local/opt/coreutils/libexec/gnubin $PATH

        contains /opt/local/bin $PATH
        or set -x PATH /opt/local/bin $PATH
end

function __handle_notes
  read -la f

  for v in $f
      set -l dir (dirname $v)

      echo "-------------------------------------------------------------"

      printf "Title: %s\n" (cat $dir/title)
      printf "Tags: %s\n" (cat $dir/tags)
      printf "Date: %s\n" (cat $dir/date)
      echo ""
      fold $dir/body*

      echo ""
      echo ""
  end
end

function notes_by_title
  rg --files-with-matches -S $argv[1] $FISH_NOTES_DIR/*/title | __handle_notes | bat
end

function notes_by_tags
  set -l results $FISH_NOTES_DIR/*/tags

  for tag in $argv
      set results (grep -l "$tag" $results)
  end

  echo "$results" | __handle_notes | bat
end

function notes_all
  set -l notes $FISH_NOTES_DIR/*/title

  echo "$notes" | __handle_notes | bat
end

function agenda
  $EDITOR (dirname (rg --files-with-matches -wF '#TODO#' $FISH_NOTES_DIR/*/title))/body*
end

function agenda_work
  $EDITOR (dirname (rg --files-with-matches -wF '#TODO_WORK#' $FISH_NOTES_DIR/*/title))/body*
end

