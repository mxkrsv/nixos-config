{ pkgs, ... }: {
  home.packages = with pkgs; [
    # A task manager
    endeavour
  ];

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = "org.gnome.Evince.desktop";
      "image/png" = "org.gnome.Loupe.desktop";
      "image/jpeg" = "org.gnome.Loupe.desktop";
      "text/html" = "org.gnome.Epiphany.desktop";
      "x-scheme-handler/http" = "org.gnome.Epiphany.desktop";
      "x-scheme-handler/https" = "org.gnome.Epiphany.desktop";
    };
  };
}
