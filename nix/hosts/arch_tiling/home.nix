{ ... }: 

let shared = import ../../shared.nix; pkgs = import sources.nixpkgs { };
  programs = import ../../programs/default.nix;

  clojure = (import ../../languages/clojure/default.nix) { inherit pkgs sources; };

  sources = import ../../nix/sources.nix;

  fish = programs.fish { inherit pkgs sources; };

  alacrittyYaml = (import ../../programs/alacritty/default.nix { inherit pkgs sources; }).linux;

in
{
  imports = [
    (import ../../modules/neovim.nix)
    (programs.nvim { inherit pkgs sources; })
    fish.config
    clojure.config
    programs.tmux.config
    programs.redshift
    (programs.git { inherit pkgs; })
  ];

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; shared.pkgs ++ [
    iotop
    xclip
    kanji-stroke-order-font
    source-han-sans-japanese
    source-han-serif-japanese
  ];

  nixpkgs.overlays = [
    (import ../../programs/neovim/overlay.nix { inherit pkgs sources; })
  ];

  programs.fish.shellInit = ''
    set -x SHELL ${pkgs.fish}/bin/fish
    set -x FISH_NOTES_DIR /data/fish_notes
    set -x FISH_JOURNAL_DIR /data/fish_journal
  '';

  # https://github.com/rycee/home-manager/blob/master/modules/targets/generic-linux.nix#blob-path
  targets.genericLinux.enable = true;

  programs.alacritty.enable = false;
  xdg.configFile."alacritty/alacritty.yml".text = "${builtins.readFile alacrittyYaml}" + ''
    shell:
      args:
        - "-l"
      program: ${pkgs.fish}/bin/fish
  '';

  services.lorri.enable = true;
  services.lorri.package = pkgs.lorri;

  programs.direnv.enable = true;

  # This adds the fish shell hook to programs.fish.shellInit
  # https://github.com/rycee/home-manager/blob/master/modules/programs/direnv.nix#blob-path
  programs.direnv.enableFishIntegration = true;
  programs.direnv.enableNixDirenvIntegration = true;

  # https://github.com/rycee/home-manager/issues/432
  programs.man.enable = false;
  home.extraOutputsToInstall = [ "man" ];

  programs.home-manager = {
    enable = true;
  };

  # https://gist.github.com/peti/2c818d6cb49b0b0f2fd7c300f8386bc3
  home.sessionVariables = {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
  };

  services.sxhkd = {
    enable = true;

    extraPath = "/home/tifa/bin:/home/tifa/.nix-profile/bin:/usr/local/bin:/usr/bin/:/usr/local/sbin/";

    keybindings = {
      # terminal emulator
      # Check if this can link to the derivation directly
      "super + Return" = "alacritty";
      # program launcher
      "super + @space" = "${pkgs.rofi}/bin/rofi -show combi";
      # make sxhkd reload its configuration files:
      "super + Escape" = "pkill -USR1 -x sxhkd";
      # Toggle dunst
      "super + alt + p" = "notify-send \"DUNST_COMMAND_TOGGLE\"";
      # Send node to different layer
      "super + alt + {u,d,m}" = "bspc node -l {above,below,normal}";
      # Reset splits
      "super + R" = "bspc node @/ --equalize";
      # quit/restart bspwm
      "super + alt + {q,r}" = "bspc {quit,wm -r}";
      # close and kill
      "super + {_,shift + }w" = "bspc node -{c,k}";
      # alternate between the tiled and monocle layout
      "super + m" = "bspc desktop -l next";
      # send the newest marked node to the newest preselected node
      "super + y" = "bspc node newest.marked.local -n newest.!automatic.local";
      # swap the current node and the biggest node
      "super + g" = "bspc node -s biggest";
      # rotate the desktop by 90deg.
      # syntax appears to be that @/ is a PATH selection
      # `node` takes a NODE_SEL and PATH is a possible value
      # the intial node for path jumps is the focused unless path starts with /
      # so this selects the root node of the current desktop (?)
      "super + r" = "bspc node @/ -R 90";
      # set the window state
      "super + {t,shift + t,s,f}" = "bspc node -t {tiled,pseudo_tiled,floating,fullscreen}";
      # set the node flags
      "super + ctrl + {m,x,y,z}" = "bspc node -g {marked,locked,sticky,private}";
      # focus the node in the given direction
      "super + {_,shift + }{h,j,k,l}" = "bspc node -{f,s} {west,south,north,east}";
      # focus the node for the given path jump
      "super + {p,b,comma,period}" = "bspc node -f @{parent,brother,first,second}";
      # focus the next/previous node in the current desktop
      "super + {_,shift + }c" = "bspc node -f {next,prev}.local";
      # focus the next/previous desktop in the current monitor
      "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
      # focus the last node/desktop
      "super + {grave,Tab}" = "bspc {node,desktop} -f last";
      # focus the older or newer node in the focus history
      "super + {o,i}" = "bspc wm -h off; bspc node {older,newer} -f; bspc wm -h on";
      # focus or send to the given desktop
      "super + {_,shift + }{1-9,0}" = "bspc {desktop -f,node -d} '^{1-9,10}'";
      # preselect the direction
      "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
      # preselect the ratio
      "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
      # cancel the preselection for the focused node
      "super + ctrl + space" = "bspc node -p cancel";
      # cancel the preselection for the focused desktop
      "super + ctrl + shift + space" = "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
      # expand a window by moving one of its side outward
      "super + alt + {h,j,k,l}" = "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
      # contract a window by moving one of its side inward
      "super + alt + shift + {h,j,k,l}" = "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
      # move a floating window
      "super + {Left,Down,Up,Right}" = "bspc node -v {-20 0,0 20,0 -20,20 0}";
      # media keys
      "XF86AudioRaiseVolume" = "pactl set-sink-volume @DEFAULT_SINK@ +5%";
      "XF86AudioLowerVolume" = "pactl set-sink-volume @DEFAULT_SINK@ -5%";
      "XF86AudioMute" = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
    };
  };

  programs.rofi = {
    enable = true;
    theme = "Arc";
    # This is in Xresources format. Get a list of possible values with rofi -dump-xresources
    extraConfig = ''
      rofi.modi: combi,window,drun,ssh
      rofi.combi-modi: window,run
      rofi.window-format: {c}       {t}
      rofi.font: Operator Mono SSm 12
    '';
  };

  services.dunst = {
    enable = true;
    settings = {
      global = {
        geometry = "500x25-30+50";
        padding = 24;
        horizontal_padding = 24;
        frame_width = 0;
        frame_color = "#aaaaaa";
        font = "Hack 12";
      };
      urgency_low = {
        background = "#222222";
        foreground = "#999999";
        timeout = 10;
      };
      urgency_normal = {
        background = "#222222";
        foreground = "#ffffff";
        timeout = 10;
      };
      urgency_critical = {
        background = "#900000";
        foreground = "#ffffff";
        timeout = 0;
      };
    };
  };

  pam.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  xdg.mime.enable = true;

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      "application/xhtml+html" = [ "firefox-developer-edition" ];
      "text/html" = [ "firefox-developer-edition.desktop" ];
      "x-scheme-handler/http" = [ "firefox-developer-edition.desktop" ];
      "x-scheme-handler/https" = [ "firefox-developer-edition.desktop" ];
      "x-scheme-handler/about" = [ "firefox-developer-edition.desktop" ];
      "x-scheme-handler/unknown" = [ "firefox-developer-edition.desktop" ];
      "x-scheme-handler/ftp" = [ "firefox-developer-edition.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-htm" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-html" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-shtml" = [ "firefox-developer-edition.desktop" ];
      "application/xhtml+xml" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-xhtml" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-xht" = [ "firefox-developer-edition.desktop" ];
    };

    associations.added = {
      "x-scheme-handler/ftp" = [ "firefox-developer-edition.desktop" ];
      "x-scheme-handler/chrome" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-htm" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-html" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-shtml" = [ "firefox-developer-edition.desktop" ];
      "application/xhtml+xml" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-xhtml" = [ "firefox-developer-edition.desktop" ];
      "application/x-extension-xht" = [ "firefox-developer-edition.desktop" ];
    };
  };

  xdg.configFile."picom.conf".text = ''
    backend = "glx";
    blur: {
        method = "gaussian";
        strength = 10;
        background = false;
        background-frame = false;
        background-fixed = false;
    }
  '';

  # Usual problem, can't find my GLX stuff in Arch host
  services.picom = {
    enable = false;
    backend = "glx";
    extraOptions = ''
      blur: {
          method = "gaussian";
          strength = 10;
          background = false;
          background-frame = false;
          background-fixed = false;
      }
    '';
  };

  # https://rycee.net/posts/2017-07-02-manage-your-home-with-nix.html#x-session
  # https://github.com/rycee/home-manager/blob/f8b03f5750679d6686eefa60d5de8cfd932b8997/modules/services/random-background.nix#L44-L60
  # https://github.com/rycee/home-manager/blob/f8b03f5750679d6686eefa60d5de8cfd932b8997/modules/xsession.nix#L130-L151
  # https://logs.nix.samueldr.com/home-manager/2019-04-07
  # https://rycee.gitlab.io/home-manager/options.html#opt-xsession.windowManager.bspwm.monitors
  xresources.extraConfig = ''
    Xft.dpi: 96
  '';

  xsession = {
    enable = true;

    profileExtra = ''
      # key repeat and delay
      xset r rate 200 60

      # Actual monitor DPI at home is something different but I don't like large
      # fonts and UI elements. I don't want scaling
      xrandr --dpi 96

      # Screensaver timeout
      xset s 300

      # caps to esc
      setxkbmap -option ctrl:nocaps -layout us -variant altgr-intl

      # Change cursor shape from default X
      xsetroot -cursor_name left_ptr

      export GTK_IM_MODULE=fcitx
      export QT_IM_MODULE=fcitx
      export XMODIFIERS=@im=fcitx
    '';

    windowManager.bspwm = {
      enable = true;
      # TODO: Convert to rules etc.
      # https://rycee.gitlab.io/home-manager/options.html#opt-xsession.windowManager.bspwm.monitors
      extraConfig = ''
        ~/.fehbg &

        bspc monitor -d                    . . . . . . 

        bspc config border_width           0
        bspc config window_gap             40
        bspc config normal_border_color    \#000000
        bspc config focused_border_color   \#CB1B45

        bspc config split_ratio            0.55
        bspc config borderless_monocle     true
        bspc config gapless_monocle        false
        bspc config single_monocle         true

        bspc config top_monocle_padding    100
        bspc config right_monocle_padding  300
        bspc config left_monocle_padding   300
        bspc config bottom_monocle_padding 100

        bspc rule -a                       Dunst state=floating
        bspc rule -a                       Screenkey manage=off
        bspc rule -a                       Zoom state=floating
      '';
    };
  };

  services.polybar = {
    enable = true;

    script = ''
      # https://github.com/jonhoo/configs/blob/master/gui/.config/polybar/launch.sh
      killall -q ${pkgs.polybar}/bin/polybar

      # Wait until processes have been shut down
      while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

      exec ${pkgs.polybar}/bin/polybar --reload main
    '';

    extraConfig = ''
      [bar/main]
      monitor =
      bottom = false
      module-margin = 2
      padding = 1
      wm-restack = bspwm

      background = #00000000
      foreground = #000000

      offset-y = 0

      border-size = 
      border-color = 

      font-0 = "Hack:size=11;2"
      font-1 = "Source Han Sans JP:size=11;2"
      font-2 = "Noto Sans Symbols:size=10;1"
      font-3 = "Noto Sans Symbols2:size=10;1"

      /* modules-left = date xwindow */
      modules-left = xwindow
      modules-center = bspwm
      /* modules-right = wlan pulseaudio cpu memory filesystem */
      separator = "|"

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
      format-foreground = #aaa

      label = "%date% %time%"

      [module/bspwm]
      type = internal/bspwm
      label-focused = " x "
      label-occupied = " . "
      label-occupied-foreground = #000
      label-empty = " %name% "
      label-empty-foreground = #888888

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
      mount-1 = /data

      label-mounted = %mountpoint%: %percentage_free%% of %total%

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

      ; Sink to be used, if it exists (find using `pacmd list-sinks`, name field)
      ; If not, uses default sink
      sink = alsa_output.pci-0000_07_04.0.analog-stereo

      ; Use PA_VOLUME_UI_MAX (~153%) if true, or PA_VOLUME_NORM (100%) if false
      ; Default: true
      use-ui-max = true

      ; Interval for volume increase/decrease (in percent points)
      ; Default: 5
      interval = 5

      label-muted = "muted"
      label-muted-foreground = #666
      label-volume = "vol: %percentage%%"

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

  home.stateVersion = "20.03";
}
