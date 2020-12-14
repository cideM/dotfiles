{ pkgs, config, ... }:
let
  alacCfg = config.programs.alacritty;
in
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = false;
    extraConfig = ''
      set -g default-terminal "tmux-256color"

      set-option -g mouse off

      set-window-option -g mode-keys vi

      # Describe outer terminal for overrides!
      set -as terminal-overrides ',*:Tc'

      set-option -g focus-events

      # Renumber windows when one is closed otherwise you end up with e.g., 1 2 5
      set-option -g renumber-window on

      set-option -g history-limit 900000

      set-option -g default-shell $SHELL

      set-option -g status-position "bottom"

      # Set ` as prefix. Type ` twice to actually type `
      unbind c-b
      set-option -g prefix `
      bind ` send-prefix

      # set is an alias for set-option
      # set -w is equivalent to set-window-option
      set -wg mode-keys vi
      set -wg main-pane-width 130
      set -wg main-pane-height 30

      set -sg escape-time 0

      set-option -g status-interval 5

      set -g automatic-rename on
      set -g automatic-rename-format '#{b:pane_current_path}'

      # -------------------------------------------------------------------
      # Key bindings
      # -------------------------------------------------------------------

      # Vim style pane selection
      bind h select-pane -L
      bind j select-pane -D 
      bind k select-pane -U
      bind l select-pane -R

      bind-key tab select-pane -t :.+
      bind-key btab select-pane -t :.-

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi r send-keys -X rectangle-toggle

      # choose-*
      bind T choose-tree
      bind W choose-window
      bind B choose-buffer

      bind C new-session

      bind X kill-pane -a
      # kill without confirm
      bind x kill-pane

      # resizing
      bind L resize-pane -R 10
      bind H resize-pane -L 10
      bind J resize-pane -D 5
      bind K resize-pane -U 5

      # join marked pane here
      bind M-j join-pane

      bind O rotate-window

      bind "'" last-window

      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -c "#{pane_current_path}"

      bind c new-window -c "#{pane_current_path}"

      # Moving windows
      bind -r > swap-window -d -t :+
      bind -r < swap-window -d -t :-

      bind / next-layout

      bind R source-file ~/.tmux.conf \; display-message "Reloaded!"
      # -------------------------------------------------------------------
      # Decoration (256-color)
      # -------------------------------------------------------------------
      set-option -g status-justify left
      set-option -g status-left '#[fg=colour7] #S #h'
      set-option -g status-left-length 30
      set-option -g status-bg default
      set-option -g status-right ' #[fg=colour7] #(date "+%a %b %d %H:%M") '

      set-option -g pane-active-border-style fg=colour2
      set-option -g pane-border-style fg=colour7
      set-option -g pane-border-status bottom
      set-option -g pane-border-format "#{b:pane_title}"

      set-window-option -g window-status-format '#[fg=colour7] [#I] #W #F'
      set-window-option -g window-status-current-format '#[fg=colour2] [#I] #W #F'
    '';
  };
}
