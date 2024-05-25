{ ... }: {
  services.kanshi = {
    enable = true;

    settings = [
      {
        profile = {
          name = "undocked";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
        };
      }
      {
        profile = {
          name = "docked";
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
      }
    ];
  };
}
