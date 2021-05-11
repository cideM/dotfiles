{ pkgs, ... }:
{
  xsession = {
    windowManager.bspwm = {
      startupPrograms = [ "fcitx5" "~/.fehbg" ];
      enable = true;
      # TODO: Convert to rules etc.
      # https://rycee.gitlab.io/home-manager/options.html#opt-xsession.windowManager.bspwm.monitors
      extraConfig = ''
        bspc monitor -d                    . . . . . . 

        bspc config window_gap             40
        bspc config border_width           2
        bspc config normal_border_color    \#b4aba7
        bspc config focused_border_color   \#DCD7F9

        bspc config split_ratio            0.55
        bspc config borderless_monocle     false
        bspc config gapless_monocle        false
        bspc config single_monocle         true

        bspc rule -a                       Dunst state=floating
        bspc rule -a                       Screenkey manage=off
        bspc rule -a                       Zoom state=floating
      '';
    };
  };

  services.sxhkd = {
    enable = true;
    extraConfig = ''
      #
      # wm independent hotkeys
      #

      # terminal emulator
      super + Return
        alacritty

      # program launcher
      super + @space
        rofi -show combi

      # Switch applications on current workspace
      super + d
        ${pkgs.rofi}/bin/rofi -show window

      # make sxhkd reload its configuration files:
      super + Escape
        pkill -USR1 -x sxhkd

      #
      # bspwm hotkeys
      #

      # Move root node (this desktop) to desktop with number
      super + ctrl + shift + {1-9} 
          bspc node -f @/; bspc node -d "^{1-9}"

      # Toggle dunst
      super + alt + p
          notify-send "DUNST_COMMAND_TOGGLE"

      # Increase and decrease gaps
      super + ctrl + w
          set next (math (bspc config window_gap) + 5); if test $next -lt 200; bspc config window_gap $next; end

      super + ctrl + n
          set next (math (bspc config window_gap) - 5); if test $next -gt 0; bspc config window_gap $next; end

      # Send node to different layer
      super + alt + {u,d,m}
          bspc node -l {above,below,normal}

      # Reset splits
      super + R
        bspc node @/ --equalize

      # quit/restart bspwm
      super + alt + {q,r}
        bspc {quit,wm -r}

      # close and kill
      super + {_,shift + }w
        bspc node -{c,k}

      # alternate between the tiled and monocle layout
      super + m
        bspc desktop -l next

      # Move current window to pre-selected space
      super + y
        bspc node -n last.!automatic.local

      # Lock screen
      super + shift + x
        betterlockscreen -l

      # swap the current node and the biggest node on current workspace
      super + g
        bspc node -s biggest.local

      # Rotate nodes including their splits and ratios
      super + r ; r
          bspc node @/ -R 90

      # Rotate nodes but keep splits and ratios
      super + shift + {d,a}
          bspc node @/ -C {forward,backward}

      #
      # state/flags
      #

      # set the window state
      super + {t,shift + t,s,f}
        bspc node -t {tiled,pseudo_tiled,floating,fullscreen}

      # set the node flags
      super + ctrl + {m,x,y,z,h}
        bspc node -g {marked,locked,sticky,private,hidden}

      #
      # focus/swap
      #

      # focus the node in the given direction
      super + {_,shift + }{h,j,k,l}
        bspc node -{f,s} {west,south,north,east}

      # focus the node for the given path jump
      super + {p,b,comma,period}
        bspc node -f @{parent,brother,first,second}

      # focus the next/previous node in the current desktop
      super + {_,shift + }c
        bspc node -f {next,prev}.local.leaf

      # focus the next/previous desktop in the current monitor
      super + bracket{left,right}
        bspc desktop -f {prev,next}.local

      # focus the last node/desktop
      super + {grave,Tab}
        bspc {node,desktop} -f last

      # focus the older or newer node in the focus history
      super + {o,i}
        bspc wm -h off; \
        bspc node {older,newer} -f; \
        bspc wm -h on

      # focus or send to the given desktop
      super + {_,shift + }{1-9,0}
        bspc {desktop -f,node -d} '^{1-9,10}'

      #
      # preselect
      #

      # preselect the direction
      super + ctrl + {h,j,k,l}
        bspc node -p {west,south,north,east}

      # preselect the ratio
      super + ctrl + {1-9}
        bspc node -o 0.{1-9}

      # cancel the preselection for the focused node
      super + ctrl + space
        bspc node -p cancel

      # cancel the preselection for the focused desktop
      super + ctrl + shift + space
        bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel

      #
      # move/resize
      #

      # expand a window by moving one of its side outward
      super + alt + {h,j,k,l}
        bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}

      # contract a window by moving one of its side inward
      super + alt + shift + {h,j,k,l}
        bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}

      # move a floating window
      super + {Left,Down,Up,Right}
        bspc node -v {-20 0,0 20,0 -20,20 0}

      # media keys
      XF86AudioRaiseVolume
              pactl set-sink-volume @DEFAULT_SINK@ +5%

      XF86AudioLowerVolume
              pactl set-sink-volume @DEFAULT_SINK@ -5%

      XF86AudioMute
              pactl set-sink-mute @DEFAULT_SINK@ toggle
    '';
  };
}
