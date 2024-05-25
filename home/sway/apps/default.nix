{ pkgs, ... }: {
  services.mako = {
    enable = true;
    font = "JetBrains Mono 11";
    backgroundColor = "#282828e0";
    borderColor = "#ebdbb2";
    textColor = "#ebdbb2";
    progressColor = "source #cc241d";
    borderRadius = 0;
    borderSize = 2;
    defaultTimeout = 5000;
    margin = "10";
    width = 200;
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.playerctl}/bin/playerctl -a pause; ${pkgs.swaylock}/bin/swaylock";
      }
      {
        event = "lock";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
      {
        event = "unlock";
        command = "${pkgs.procps}/bin/pkill -USR1 swaylock";
      }
    ];
    extraArgs = [
      "idlehint 1200"
    ];
    timeouts = [
      {
        # turn the screen off quickly if the screen was locked manually
        timeout = 15;
        command = "${pkgs.procps}/bin/pgrep -x swaylock && \\
          ${pkgs.sway}/bin/swaymsg 'output * power off'";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
      {
        timeout = 900;
        command = "${pkgs.chayang}/bin/chayang -d10 && \\
          ${pkgs.sway}/bin/swaymsg 'output * power off' && \\
          ${pkgs.swaylock}/bin/swaylock";
        resumeCommand = "${pkgs.sway}/bin/swaymsg 'output * power on'";
      }
    ];
  };

  services.wlsunset = {
    enable = true;
    latitude = "60";
    longitude = "30";
    temperature.night = 4500;
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  gtk = {
    enable = true;
    theme.name = "Adwaita";
  };

  # Calendar things
  programs = {
    khal = {
      enable = true;

      locale = {
        timeformat = "%H:%M";
        dateformat = "%d.%m";
        longdateformat = "%d.%m.%Y";
        datetimeformat = "%d.%m %H:%M";
        longdatetimeformat = "%d.%m.%Y %H:%M";
      };
    };

    vdirsyncer = {
      enable = true;
    };
  };

  # Application launcher
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = "JetBrains Mono:size=11";
        dpi-aware = false;
        prompt = "'> '";
        terminal = "footclient";
        launch-prefix = "swaymsg exec --";

        lines = 20;
        width = 60;
        horizontal-pad = 8;
        vertical-pad = 4;
        inner-pad = 4;

        exit-on-keyboard-focus-loss = false;
      };
      colors = {
        background = "282828e0";
        text = "ebdbb2ff";
        match = "98971aff";
        selection = "ebdbb2ff";
        selection-text = "282828ff";
        border = "8ec07cff";
      };
      border = {
        width = 3;
        radius = 0;
      };
      key-bindings = {
        next = "Mod1+j Down Control+n";
        prev = "Mod1+k Up Control+p";
      };
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      osd-font = "JetBrains Mono";
      osd-font-size = 20;
      osd-color = "#ebdbb2";
      osd-border-color = "#282828";
    };
    scripts = [
      pkgs.mpvScripts.mpris
    ];
  };

  programs.imv = {
    enable = true;
    settings = {
      options = {
        background = "282828";
        overlay_text_color = "ebdbb2";
        overlay_background_color = "282828";
        overlay_background_alpha = "e0";
        overlay_font = "JetBrains Mono:11";
      };
    };
  };

  programs.zathura = {
    enable = true;
    options = {
      font = "JetBrains Mono 11";
      selection-clipboard = "clipboard";
      synctex-editor-command = "footclient nvim";

      #recolor = true;
      recolor-keephue = false;

      # base16 gruvbox
      default-bg = "#282828";
      default-fg = "#3c3836";
      statusbar-fg = "#bdae93";
      statusbar-bg = "#504945";
      inputbar-bg = "#282828";
      inputbar-fg = "#fbf1c7";
      notification-bg = "#282828";
      notification-fg = "#fbf1c7";
      notification-error-bg = "#282828";
      notification-error-fg = "#fb4934";
      notification-warning-bg = "#282828";
      notification-warning-fg = "#fb4934";
      highlight-color = "#fabd2f";
      highlight-active-color = "#83a598";
      completion-bg = "#3c3836";
      completion-fg = "#83a598";
      completion-highlight-fg = "#fbf1c7";
      completion-highlight-bg = "#83a598";
      recolor-lightcolor = "#282828";
      recolor-darkcolor = "#ebdbb2";
    };
  };
}
