{ config, pkgs, lib, ... }: {
  wayland.windowManager.sway = {
    enable = true;
    systemd.enable = true;

    # It doesn't work
    extraSessionCommands = ''
      export MOZ_ENABLE_WAYLAND=1
      export QT_QPA_PLATFORM=wayland
      export SDL_VIDEODRIVER=wayland
      export GTK_THEME=Adwaita:dark

      export EDITOR=nvim
      export VISUAL=nvim
    '';

    swaynag = {
      enable = true;
      settings = {
        "<config>" = {
          edge = "bottom";
          font = "JetBrains Mono 10";
          border-bottom-size = "0";
        };
        warning = {
          background = "fabd2f";
          text = "282828";
          border = "282828";
          button-background = "b8bb26";
        };
      };
    };

    wrapperFeatures.gtk = true;

    config = {
      modifier = "Mod4";
      bindkeysToCode = true;
      terminal = "${pkgs.foot}/bin/footclient";
      menu = "${pkgs.fuzzel}/bin/fuzzel";
      workspaceAutoBackAndForth = true;

      startup = [
        { command = "foot --server"; }
      ];

      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
        }
      ];

      colors =
        let
          black = "#282828";
          red = "#cc241d";
          green = "#98971a";
          yellow = "#d79921";
          blue = "#458588";
          purple = "#b16286";
          aqua = "#689d6a";
          gray = "#a89984";
          brgray = "#928374";
          brred = "#fb4934";
          brgreen = "#b8bb26";
          bryellow = "#fabd2f";
          brblue = "#83a598";
          brpurple = "#d3869b";
          braqua = "#8ec07c";
          white = "#ebdbb2";

          a = "e0";
          focused = braqua;
          inactive = purple;
          unfocused = black;
          urgent = yellow;
        in
        {
          focused = {
            border = focused;
            background = focused;
            text = black;
            indicator = brred;
            childBorder = "";
          };
          focusedInactive = {
            border = inactive;
            background = inactive;
            text = white;
            indicator = red;
            childBorder = "";
          };
          unfocused = {
            border = unfocused;
            background = unfocused;
            text = white;
            indicator = red;
            childBorder = "";
          };
          urgent = {
            border = urgent;
            background = urgent;
            text = black;
            indicator = red;
            childBorder = "";
          };
        };

      floating = {
        border = 2;
        titlebar = true;
        criteria = [
          {
            app_id = "^floating_foot$";
          }
        ];
      };

      focus = {
        newWindow = "urgent";
      };

      fonts = {
        names = [ "JetBrains Mono" ];
        size = 10.0;
      };

      gaps = {
        smartGaps = true;
        smartBorders = "on";
        inner = 10;
        outer = 0;
      };

      output = {
        "*" = {
          bg = "`find ~/.wallpaper -type f | shuf -n1` fill #282828";
        };
        "AU Optronics 0x408D Unknown" = {
          scale = "1.5";
        };
      };

      input = {
        "type:pointer" = {
          accel_profile = "flat";
        };
        "type:keyboard" = {
          xkb_layout = "us,ru";
          xkb_options = "grp:caps_toggle";
        };
        "type:touchpad" = {
          accel_profile = "flat";
          tap = "yes";
          dwt = "yes";
          tap_button_map = "lrm";
          natural_scroll = "yes";
        };
        "2:7:SynPS/2_Synaptics_TouchPad" = {
          pointer_accel = "0.5";
        };
        "2:10:TPPS/2_Elan_TrackPoint" = {
          pointer_accel = "0.5";
        };
      };

      keybindings =
        let
          mod = config.wayland.windowManager.sway.config.modifier;
          up = config.wayland.windowManager.sway.config.up;
          down = config.wayland.windowManager.sway.config.down;
          left = config.wayland.windowManager.sway.config.left;
          right = config.wayland.windowManager.sway.config.right;
          floating_term = "${config.wayland.windowManager.sway.config.terminal} -a floating_foot";
        in
        lib.mkOptionDefault {
          # File manager
          "${mod}+o" = "exec ${floating_term} ${pkgs.lf}/bin/lf";

          # Media keys
          XF86MonBrightnessDown = "exec ${pkgs.light}/bin/light -T 0.72";
          XF86MonBrightnessUp = "exec ${pkgs.light}/bin/light -T 1.4";

          XF86AudioRaiseVolume = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
          XF86AudioLowerVolume = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
          XF86AudioMute = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          XF86AudioMicMute = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          XF86AudioPlay = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          XF86AudioNext = "exec ${pkgs.playerctl}/bin/playerctl next";
          XF86AudioPrev = "exec ${pkgs.playerctl}/bin/playerctl previous";
          XF86AudioStop = "exec ${pkgs.playerctl}/bin/playerctl stop";
          Pause = "exec ${pkgs.playerctl}/bin/playerctl pause";

          XF86NotificationCenter = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

          XF86Favorites = "exec ${config.wayland.windowManager.sway.config.menu}";

          XF86Display = "output eDP-1 toggle";

          # General actions
          "${mod}+Shift+Return" = "exec ${floating_term}";

          "${mod}+p" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy output";
          Print = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy output";
          "${mod}+Shift+p" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          XF86SelectiveScreenshot = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy area";
          "${mod}+Ctrl+p" = "exec ${pkgs.sway-contrib.grimshot}/bin/grimshot copy window";

          # Workspaces
          "${mod}+Ctrl+${up}" = "workspace prev_on_output";
          "${mod}+Ctrl+${down}" = "workspace next_on_output";
          "${mod}+Ctrl+Up" = "workspace prev_on_output";
          "${mod}+Ctrl+Down" = "workspace next_on_output";

          "${mod}+Ctrl+Shift+${up}" = "move container to workspace prev_on_output";
          "${mod}+Ctrl+Shift+${down}" = "move container to workspace next_on_output";
          "${mod}+Ctrl+Shift+Up" = "move container to workspace prev_on_output";
          "${mod}+Ctrl+Shift+Down" = "move container to workspace next_on_output";

          # Outputs
          "${mod}+Ctrl+${left}" = "focus output left";
          "${mod}+Ctrl+${right}" = "focus output right";
          "${mod}+Ctrl+Left" = "focus output left";
          "${mod}+Ctrl+Right" = "focus output right";

          "${mod}+Ctrl+Shift+${left}" = "move workspace to output left";
          "${mod}+Ctrl+Shift+${right}" = "move workspace to output right";
          "${mod}+Ctrl+Shift+Left" = "move workspace to output left";
          "${mod}+Ctrl+Shift+Right" = "move workspace to output right";

          # Global fullscreen
          "${mod}+Shift+f" = "fullscreen toggle global";

          # Modes
          "${mod}+Equal" = "mode passthrough";
          "${mod}+c" = "mode config";
        };

      modes = lib.mkOptionDefault {
        passthrough = {
          "${config.wayland.windowManager.sway.config.modifier}+Equal" =
            "mode default";
        };
        config = {
          p = "exec swaynag -t warning -m 'Poweroff?' -b 'Yes' 'systemctl poweroff'; mode default";
          r = "exec swaynag -t warning -m 'Reboot?' -b 'Yes' 'systemctl reboot'; mode default";
          s = "exec systemctl suspend; mode default";
          "--release l" = "exec pkill -USR1 swayidle; mode default";

          b = "exec ${pkgs.light}/bin/light -T 1.4";
          "Shift+b" = "exec ${pkgs.light}/bin/light -T 0.72";

          v = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ +1%";
          "Shift+v" = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-volume @DEFAULT_SINK@ -1%";
          m = "exec ${pkgs.pulseaudio}/bin/pactl set-sink-mute @DEFAULT_SINK@ toggle";
          "Shift+m" = "exec ${pkgs.pulseaudio}/bin/pactl set-source-mute @DEFAULT_SOURCE@ toggle";

          z = "exec ${pkgs.playerctl}/bin/playerctl previous";
          x = "exec ${pkgs.playerctl}/bin/playerctl play-pause";
          c = "exec ${pkgs.playerctl}/bin/playerctl next";

          n = "exec ${pkgs.mako}/bin/makoctl dismiss -a";

          Return = "mode default";
          Escape = "mode default";
        };
      };

      seat = {
        "*" = {
          hide_cursor = "4000";
          idle_wake = "keyboard";
          xcursor_theme = "Adwaita 24";
        };
      };

      window = {
        border = 2;
        titlebar = false;
      };

    };

    extraConfig = ''
      ### Touchpad bindings
      bindgesture {
             # Workspaces
             swipe:3:right workspace prev
             swipe:3:left workspace next
      
             # Kill active window
             swipe:3:down kill
      
             # Toggle floating
             swipe:3:up floating toggle
      
             # Scratchpad
             pinch:2:inward+down move scratchpad
             pinch:2:outward+up scratchpad show
      
             # Move active window
             swipe:4:left move left
             swipe:4:right move right
             swipe:4:up move up
             swipe:4:down move down
      }
    '';
  };
}
