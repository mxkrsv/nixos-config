{ pkgs, config, ... }: {
  accounts.calendar.basePath = "${config.xdg.dataHome}/calendar";

  accounts.calendar.accounts.main = {
    primary = true;
    primaryCollection = "Personal";

    local = {
      fileExt = ".ics";
      type = "filesystem";
    };

    remote = {
      type = "caldav";
      url = "https://cloud.disroot.org/remote.php/dav";
      userName = "mxkrsv";
      passwordCommand = [
        "${pkgs.rbw}/bin/rbw"
        "get"
        "disroot.org"
      ];
    };

    khal = {
      enable = true;
      type = "discover";
    };

    vdirsyncer = {
      enable = true;
      collections = [ "personal" "work" "etu" ];
      metadata = [ "color" "displayname" ];
    };
  };
}
