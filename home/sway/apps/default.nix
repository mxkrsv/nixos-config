{ pkgs, ... }: {
  imports = [
    ./aerc
  ];

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

  programs.swaylock = {
    enable = true;
    settings = {
      font = "JetBrains Mono";
      font-size = 20;
      show-failed-attempts = true;
      daemonize = true;
      color = "282828";

      separator-color = "282828";
      layout-bg-color = "d3869b";
      layout-border-color = "b16286";
      layout-text-color = "282828";

      bs-hl-color = "fb4934";
      key-hl-color = "b8bb26";
      inside-color = "d3869b";
      line-color = "282828";
      ring-color = "b16286";
      text-color = "282828";

      caps-lock-bs-hl-color = "cc241d";
      caps-lock-key-hl-color = "98971a";
      inside-caps-lock-color = "83a598";
      line-caps-lock-color = "ebdbb2";
      ring-caps-lock-color = "458588";
      text-caps-lock-color = "282828";

      inside-clear-color = "8ec07c";
      line-clear-color = "282828";
      ring-clear-color = "689d6a";
      text-clear-color = "282828";

      inside-ver-color = "fabd2f";
      line-ver-color = "282828";
      ring-ver-color = "d79921";
      text-ver-color = "282828";

      inside-wrong-color = "fb4934";
      line-wrong-color = "282828";
      ring-wrong-color = "cc241d";
      text-wrong-color = "282828";
    };
  };

  programs.qutebrowser = {
    enable = true;

    searchEngines = {
      DEFAULT = "https://www.google.com/search?q={}";
      "!repology" = "https://repology.org/projects/?search={}";
      "!reversocontext" = "https://context.reverso.net/translation/english-russian/{}";
      "!nixos-packages" = "https://search.nixos.org/packages?query={}";
      "!nixos-options" = "https://search.nixos.org/options?query={}";
    };

    settings = {
      auto_save.session = true;
      session.lazy_restore = true;
      colors.webpage = {
        preferred_color_scheme = "dark";
        #darkmode.enabled = true;
      };
      content.autoplay = false;
      fonts = {
        default_family = "JetBrains Mono";
        default_size = "11pt";
      };
      url = {
        default_page = "https://www.google.com/";
        start_pages = "https://www.google.com/";
      };
    };

    extraConfig = ''
      # Gruvbox theme

      fg0 = "#fbf1c7"
      fg = '#ebdbb2'
      fg3 = "#bdae93"
      bg = '#282828'
      bg1 = '#3c3836'
      bg2 = "#504945"
      bg3 = "#665c54"
      brred = "#fb4934"
      brgreen = "#b8bb26"
      bryellow = "#fabd2f"
      brblue = "#83a598"
      brpurple = "#d3869b"
      braqua = "#8ec07c"
      blue = "#458588"
      green = "#98971a"
      purple = "#b16286"
      orange = "#d65d0e"
      red = "#cc241d"
      aqua = "#689d6a"
      gray = "#a89984"

      c.colors.completion.fg = fg
      c.colors.completion.odd.bg = bg1
      c.colors.completion.even.bg = bg
      c.colors.completion.category.fg = bryellow
      c.colors.completion.category.bg = bg
      c.colors.completion.category.border.top = bg
      c.colors.completion.category.border.bottom = bg
      c.colors.completion.item.selected.fg = bg
      c.colors.completion.item.selected.bg = fg
      c.colors.completion.item.selected.border.top = fg
      c.colors.completion.item.selected.border.bottom = fg
      c.colors.completion.item.selected.match.fg = green
      c.colors.completion.match.fg = brgreen
      c.colors.completion.scrollbar.fg = fg
      c.colors.completion.scrollbar.bg = bg

      c.colors.contextmenu.disabled.bg = bg1
      c.colors.contextmenu.disabled.fg = fg3
      c.colors.contextmenu.menu.bg = bg
      c.colors.contextmenu.menu.fg = fg
      c.colors.contextmenu.selected.bg = bg2
      c.colors.contextmenu.selected.fg = fg

      c.colors.downloads.bar.bg = bg
      c.colors.downloads.start.fg = bg
      c.colors.downloads.start.bg = brblue
      c.colors.downloads.stop.fg = bg
      c.colors.downloads.stop.bg = braqua
      c.colors.downloads.error.fg = brred

      c.colors.hints.fg = bg
      c.colors.hints.bg = bryellow
      c.colors.hints.match.fg = fg

      c.colors.keyhint.fg = fg
      c.colors.keyhint.suffix.fg = fg
      c.colors.keyhint.bg = bg

      c.colors.messages.error.fg = bg
      c.colors.messages.error.bg = brred
      c.colors.messages.error.border = brred
      c.colors.messages.warning.fg = bg
      c.colors.messages.warning.bg = brpurple
      c.colors.messages.warning.border = brpurple
      c.colors.messages.info.fg = fg
      c.colors.messages.info.bg = bg
      c.colors.messages.info.border = bg

      c.colors.prompts.fg = fg
      c.colors.prompts.border = f"1px solid {bg2}"
      c.colors.prompts.bg = bg
      c.colors.prompts.selected.bg = bg2
      c.colors.prompts.selected.fg = fg

      c.colors.statusbar.normal.fg = brgreen
      c.colors.statusbar.normal.bg = bg
      c.colors.statusbar.insert.fg = fg
      c.colors.statusbar.insert.bg = purple
      c.colors.statusbar.passthrough.fg = fg
      c.colors.statusbar.passthrough.bg = bg2
      c.colors.statusbar.private.fg = bg
      c.colors.statusbar.private.bg = bg1
      c.colors.statusbar.command.fg = fg
      c.colors.statusbar.command.bg = bg
      c.colors.statusbar.command.private.fg = fg
      c.colors.statusbar.command.private.bg = bg
      c.colors.statusbar.caret.fg = fg
      c.colors.statusbar.caret.bg = red
      c.colors.statusbar.caret.selection.fg = fg
      c.colors.statusbar.caret.selection.bg = orange
      c.colors.statusbar.progress.bg = brblue
      c.colors.statusbar.url.fg = fg
      c.colors.statusbar.url.error.fg = brred
      c.colors.statusbar.url.hover.fg = fg
      c.colors.statusbar.url.success.http.fg = braqua
      c.colors.statusbar.url.success.https.fg = bryellow
      c.colors.statusbar.url.warn.fg = brpurple

      c.colors.tabs.bar.bg = bg
      c.colors.tabs.indicator.start = purple
      c.colors.tabs.indicator.stop = green
      c.colors.tabs.indicator.error = brred
      c.colors.tabs.odd.fg = fg
      c.colors.tabs.odd.bg = bg1
      c.colors.tabs.even.fg = fg
      c.colors.tabs.even.bg = bg
      c.colors.tabs.pinned.even.fg = fg0
      c.colors.tabs.pinned.even.bg = bg2
      c.colors.tabs.pinned.odd.fg = fg0
      c.colors.tabs.pinned.odd.bg = bg3
      c.colors.tabs.pinned.selected.even.fg = bg
      c.colors.tabs.pinned.selected.even.bg = fg
      c.colors.tabs.pinned.selected.odd.fg = bg
      c.colors.tabs.pinned.selected.odd.bg = fg
      c.colors.tabs.selected.odd.fg = bg
      c.colors.tabs.selected.odd.bg = fg
      c.colors.tabs.selected.even.fg = bg
      c.colors.tabs.selected.even.bg = fg
    '';
  };

  services.syncthing.tray.enable = true;

  programs.foot = {
    enable = true;
    #server.enable = true; // can't execute desktop files in that case
    settings = {
      main = {
        font = "JetBrains Mono:size=11";
        dpi-aware = false;
        pad = "0x0";
      };
      bell = {
        urgent = true;
      };
      scrollback = {
        lines = 8192;
      };
      # gruvbox
      colors = {
        background = "282828";
        foreground = "ebdbb2";
        regular0 = "282828";
        regular1 = "cc241d";
        regular2 = "98971a";
        regular3 = "d79921";
        regular4 = "458588";
        regular5 = "b16286";
        regular6 = "689d6a";
        regular7 = "a89984";
        bright0 = "928374";
        bright1 = "fb4934";
        bright2 = "b8bb26";
        bright3 = "fabd2f";
        bright4 = "83a598";
        bright5 = "d3869b";
        bright6 = "8ec07c";
        bright7 = "ebdbb2";
        alpha = "0.9";
      };
    };
  };

  xdg.desktopEntries = {
    cmus = {
      name = "cmus";
      genericName = "Music player";
      exec = "cmus %U";
      terminal = true;
      categories = [ "Audio" "Music" "ConsoleOnly" ];
    };

    newsboat = {
      name = "newsboat";
      genericName = "RSS feed reader";
      exec = "newsboat %U";
      terminal = true;
      categories = [ "Feed" "News" "Network" "ConsoleOnly" ];
    };

    qalc = {
      name = "qalc";
      genericName = "Calculator";
      exec = "qalc %U";
      terminal = true;
      categories = [ "Calculator" "Utility" "Science" "Education" "ConsoleOnly" ];
    };
  };
}
