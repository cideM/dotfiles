set -x BAT_THEME "base16"

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
abbr -a nsc 'notes search_content | rg body | xargs bat --wrap character --terminal-width 80'
abbr -a nst 'notes search_tags | rg body | xargs bat --wrap character --terminal-width 80'
alias ls exa

# opam configuration
if test -d /home/tifa/.opam/opam-init/init.fish 
    source /home/tifa/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true
end

if type -q direnv
    eval (direnv hook fish)
end

switch (hostname)
    case nixos
        set -x SHELL (which fish)
        set -x FISH_NOTES_DIR /data/fish_notes
        set -x FISH_JOURNAL_DIR /data/fish_journal
    case archminimal
        set -x SHELL (which fish)
        set -x FISH_NOTES_DIR /data/fish_notes
        set -x FISH_JOURNAL_DIR /data/fish_journal
    case fbs-work.local
        set -x SHELL (which fish)
        set -x FISH_NOTES_DIR $XDG_DATA_HOME/fish_notes
        set -x FISH_JOURNAL_DIR $XDG_DATA_HOME/fish_journal

        contains /usr/local/opt/coreutils/libexec/gnubin $PATH
        or set -x PATH /usr/local/opt/coreutils/libexec/gnubin $PATH

        contains /opt/local/bin $PATH
        or set -x PATH /opt/local/bin $PATH
    # TODO: Check NixOS hostname
    default
end
