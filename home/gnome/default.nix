{ pkgs, lib, ... }: {
  imports = [
    ./apps
  ];

  programs.gnome-shell = {
    enable = true;

    extensions = [
      {
        package = pkgs.gnomeExtensions.forge;
      }
      {
        package = pkgs.gnomeExtensions.gsconnect;
      }
      {
        package = pkgs.gnomeExtensions.vitals;
      }
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      scaling-factor = 1.5;
    };

    "org/gnome/desktop/input-sources" = {
      xkb-options = [ "terminate:ctrl_alt_bksp" "grp:caps_toggle" ];
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "us" ])
        (lib.hm.gvariant.mkTuple [ "xkb" "ru" ])
      ];
    };

    "org/gnome/mutter" = {
      experimental-features = [ "scale-monitor-framebuffer" ];
    };

    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
    };

    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      binding = "<Super>t";
      name = "Terminal";
      command = "kgx";
    };

    "org/gnome/settings-daemon/plugins/media-keys" = {
      custom-keybindings = [
        "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
      ];
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 10;
      focus-mode = "mouse";
    };

    "org/gnome/shell/keybindings" = {
      # It was Super+{number}, which is desired for workspace switching.
      switch-to-application-1 = [ "" ];
      switch-to-application-2 = [ "" ];
      switch-to-application-3 = [ "" ];
      switch-to-application-4 = [ "" ];
      switch-to-application-5 = [ "" ];
      switch-to-application-6 = [ "" ];
      switch-to-application-7 = [ "" ];
      switch-to-application-8 = [ "" ];
      switch-to-application-9 = [ "" ];
    };

    "org/gnome/desktop/wm/keybindings" = {
      # The "<Super>Home/End" was there by default, let them remain
      switch-to-workspace-1 = [ "<Super>Home" "<Super>1" ];
      switch-to-workspace-2 = [ "<Super>2" ];
      switch-to-workspace-3 = [ "<Super>3" ];
      switch-to-workspace-4 = [ "<Super>4" ];
      switch-to-workspace-5 = [ "<Super>5" ];
      switch-to-workspace-6 = [ "<Super>6" ];
      switch-to-workspace-7 = [ "<Super>7" ];
      switch-to-workspace-8 = [ "<Super>8" ];
      switch-to-workspace-9 = [ "<Super>9" ];
      switch-to-workspace-10 = [ "<Super>0" ];
      switch-to-workspace-last = [ "<Super>End" ];

      move-to-workspace-1 = [ "<Super><Shift>Home" "<Super><Shift>1" ];
      move-to-workspace-2 = [ "<Super><Shift>2" ];
      move-to-workspace-3 = [ "<Super><Shift>3" ];
      move-to-workspace-4 = [ "<Super><Shift>4" ];
      move-to-workspace-5 = [ "<Super><Shift>5" ];
      move-to-workspace-6 = [ "<Super><Shift>6" ];
      move-to-workspace-7 = [ "<Super><Shift>7" ];
      move-to-workspace-8 = [ "<Super><Shift>8" ];
      move-to-workspace-9 = [ "<Super><Shift>9" ];
      move-to-workspace-10 = [ "<Super><Shift>0" ];
      move-to-workspace-last = [ "<Super><Shift>End" ];
    };
  };
}
