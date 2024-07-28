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
