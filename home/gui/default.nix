{ pkgs, ... }: {
  imports = [
    ./sway
    ./waybar

    ./stylix
  ];

  home.packages = with pkgs; [
    gimp
    xonotic
    xonotic-data
    libreoffice-fresh
    telegram-desktop

    # fonts
    font-awesome
    jetbrains-mono
    dejavu_fonts

    # pwn
    wireshark
    # hiPrio needed due to the conflict between the rz-ghidra from rizin and cutter
    (lib.hiPrio (cutter.withPlugins (ps: with ps; [
      rz-ghidra
      sigdb
    ])))
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
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

  services.kanshi = {
    enable = true;
    profiles = {
      undocked = {
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
      };
      docked = {
        outputs = [
          {
            criteria = "eDP-1";
            position = "3840,0";
            status = "disable";
          }
          {
            criteria = "BNQ BenQ GW2480 L1M0533101Q";
            position = "1920,0";
          }
          {
            criteria = "BNQ BenQ BL2480 H1J0087401Q";
            position = "0,0";
          }
        ];
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
  };

  services.mako = {
    enable = true;
    borderRadius = 0;
    borderSize = 2;
    defaultTimeout = 5000;
    margin = "10";
    width = 200;
  };

  programs.foot = {
    enable = true;
    #server.enable = true; // can't execute desktop files in that case
    settings = {
      main = {
        pad = "0x0";
      };
      bell = {
        urgent = true;
      };
      scrollback = {
        lines = 8192;
      };
    };
  };

  programs.swaylock = {
    enable = true;
    settings = {
      show-failed-attempts = true;
      daemonize = true;

      caps-lock-bs-hl-color = "cc241d";
      caps-lock-key-hl-color = "98971a";
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
        default_size = "11pt";
      };
      url = {
        default_page = "https://www.google.com/";
        start_pages = "https://www.google.com/";
      };
    };
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

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.pwmt.zathura.desktop";
      "image/png" = "imv.desktop";
      "image/jpeg" = "imv.desktop";
      "text/html" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
      "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
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
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
    };
  };

  programs.chromium = {
    enable = true;
    commandLineArgs = [
      "--enable-ozone"
      "--ozone-platform=wayland"
    ];
    extensions = [
      # ublock origin
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
    ];
  };

  fonts.fontconfig.enable = true;

  qt = {
    enable = true;
    platformTheme = "gnome";
    style.name = "adwaita-dark";
  };

  # Imperative (for now) file synchronization
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
}
