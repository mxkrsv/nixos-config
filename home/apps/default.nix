{ pkgs, ... }: {
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
    #(lib.hiPrio (cutter.withPlugins (ps: with ps; [
    #  rz-ghidra
    #  sigdb
    #])))
  ];

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

  #xdg.mimeApps = {
  #  enable = true;
  #  defaultApplications = {
  #    "application/pdf" = "org.pwmt.zathura.desktop";
  #    "image/png" = "imv.desktop";
  #    "image/jpeg" = "imv.desktop";
  #    "text/html" = "org.qutebrowser.qutebrowser.desktop";
  #    "x-scheme-handler/http" = "org.qutebrowser.qutebrowser.desktop";
  #    "x-scheme-handler/https" = "org.qutebrowser.qutebrowser.desktop";
  #  };
  #};

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
    platformTheme.name = "adwaita";
    style.name = "adwaita-dark";
  };

  # Imperative (for now) file synchronization
  services.syncthing = {
    enable = true;
  };
}
