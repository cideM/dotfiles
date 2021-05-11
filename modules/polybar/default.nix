{ pkgs, ... }:
let
  toggleDunst = pkgs.writeShellScriptBin "toggleDunst" ''
    if [ $(${pkgs.dunst}/bin/dunstctl is-paused) = "true" ]; then
      ${pkgs.dunst}/bin/dunstctl set-paused false
      ${pkgs.polybar}/bin/polybar-msg hook dunst 1
    else
      ${pkgs.dunst}/bin/dunstctl set-paused true
      ${pkgs.polybar}/bin/polybar-msg hook dunst 2
    fi
  '';
in
{
  services.polybar = {
    enable = true;

    package = pkgs.polybarFull;

    script = ''
      polybar top &
    '';

    extraConfig = ''
      [settings]
      screenchange-reload = true

      [bar/top]
      monitor =
      bottom = false
      height = 24
      module-margin = 2
      line-color = #fba922
      border-bottom-size = 2
      border-bottom-color = #b4aba7
      underline-size = 4
      overline-size = 2
      foreground = #635954
      background = #efeae5
      padding = 4
      enable-ipc = true
      wm-restack = bspwm

      offset-y = 0

      border-size = 
      border-color = 

      font-0 = "Hack:size=10;3"
      font-1 = "Source Han Sans JP:size=11;2"
      font-2 = "RobotoMono Nerd Font:size=10;3"

      modules-left = xwindow
      modules-center = bspwm
      modules-right = dunst date wlan pulseaudio cpu memory filesystem
      separator = "|"
      separator-foreground = #b4aba7

      [module/dunst]
      type = custom/ipc
      initial = 1
      hook-0 = echo 
      hook-1 = echo 
      click-left = "${toggleDunst}/bin/toggleDunst"

      [global/wm]
      margin-top = 0

      [module/xwindow]
      type = internal/xwindow
      label = %title:0:70:...%

      [module/date]
      type = internal/date
      interval = 5

      date = "%A %m/%d/%y"
      date-alt = %a %b %d

      time = "%I:%M %p"
      time-alt = %I:%M%p

      format-prefix =

      label = "%date% %time%"

      [module/bspwm]
      type = internal/bspwm
      format = <label-state> <label-mode>
      label-monocle = " monocle mode "
      label-monocle-foreground = #a7111d
      label-monocle-background = #ffe0e0
      label-focused = " %index% "
      label-focused-underline = #5137e1
      label-occupied = " %index% "
      label-occupied-underline = #DCD7F9
      label-empty = " %index% "
      label-separator = " "
      label-separator-padding = 0

      [module/cpu]
      type = internal/cpu
      interval = 2
      format-prefix = "cpu: "
      label = %percentage:2%%

      [module/memory]
      type = internal/memory
      interval = 2
      format-prefix = "mem: "
      label = %percentage_used:2%%

      [module/filesystem]
      type = internal/fs

      ; Mountpoints to display
      mount-0 = /

      label-mounted = %mountpoint%: %percentage_free%% free of %total%

      ; Seconds to sleep between updates
      ; Default: 30
      interval = 10

      ; Display fixed precision values
      ; Default: false
      fixed-values = true

      ; Spacing between entries
      ; Default: 2
      spacing = 2

      [module/pulseaudio]
      type = internal/pulseaudio

      ; Use PA_VOLUME_UI_MAX (~153%) if true, or PA_VOLUME_NORM (100%) if false
      ; Default: true
      use-ui-max = true

      ; Interval for volume increase/decrease (in percent points)
      ; Default: 5
      interval = 5

      label-muted = "muted"
      label-volume = "vol: %percentage%%"

      click-right = "${pkgs.pavucontrol}/bin/pavucontrol"

      [module/wlan]
      type = internal/network
      interface = wlan0
      interval = 5.0

      format-connected = <label-connected> <ramp-signal> 
      label-connected = %essid%

      label-disconnected =

      ramp-signal-0 = no signal
      ramp-signal-1 = 25%
      ramp-signal-2 = 50%
      ramp-signal-3 = 75%
      ramp-signal-4 = full signal
    '';
  };
}
