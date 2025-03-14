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

    settings = {
      "privacy.resistFingerprinting" = false;
      "privacy.fingerprintingProtection" = true;
      "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
    };

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

      search = {
        force = true;
        default = "Kagi";
        privateDefault = "DuckDuckGo";
        order = [
          "Kagi"
          "Google"
          "DuckDuckGo"
        ];
        engines = {
          Kagi = {
            urls = [{
              template = "https://kagi.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];

            iconUpdateURL = "https://kagi.com/favicon.ico";
            definedAliases = [ "@kagi" "@k" ];
          };

          Google = {
            urls = [{
              template = "https://www.google.com/search";
              params = [
                { name = "q"; value = "{searchTerms}"; }
              ];
            }];

            iconUpdateURL = "https://www.google.com/favicon.ico";
            definedAliases = [ "@google" "@g" ];
          };

          "Nix Packages" = {
            urls = [{
              template = "https://search.nixos.org/packages";
              params = [
                { name = "type"; value = "packages"; }
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };

          "Nix Options" = {
            urls = [{
              template = "https://search.nixos.org/options";
              params = [
                { name = "query"; value = "{searchTerms}"; }
              ];
            }];

            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@no" ];
          };

          "NixOS Wiki" = {
            urls = [{ template = "https://wiki.nixos.org/index.php?search={searchTerms}"; }];
            iconUpdateURL = "https://wiki.nixos.org/favicon.png";
            updateInterval = 24 * 60 * 60 * 1000; # every day
            definedAliases = [ "@nw" ];
          };
        };
      };
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
