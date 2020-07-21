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
abbr -a nsc 'notes search_content | rg body | xargs bat'
abbr -a nst 'notes search_tags | rg body | xargs bat'

# opam configuration
if test -d /home/tifa/.opam/opam-init/init.fish 
    source /home/tifa/.opam/opam-init/init.fish >/dev/null 2>/dev/null; or true
end

# https://direnv.net/docs/hook.html
if type -q direnv
    eval (direnv hook fish)
end

# Source hostname specific stuff
set -l hostname_file $XDG_CONFIG_HOME/fish/(hostname).fish
if test -e $hostname_file
    source $hostname_file
end
