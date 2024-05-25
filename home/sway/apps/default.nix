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
}
