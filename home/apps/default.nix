{ pkgs, inputs, ... }: {
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

  home.file.".librewolf/default/chrome/firefox-gnome-theme".source =
    inputs.firefox-gnome-theme;
  programs.librewolf = {
    enable = true;

    profiles.default = {
      isDefault = true;

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        bitwarden
        gsconnect
        gnome-shell-integration
      ];

      userChrome = ''
        @import "firefox-gnome-theme/userChrome.css";
      '';
      userContent = ''
        @import "firefox-gnome-theme/userContent.css";
      '';
      extraConfig = builtins.readFile "${inputs.firefox-gnome-theme}/configuration/user.js";
    };
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
