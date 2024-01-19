{ pkgs, ... }: {
  stylix = {
    image = pkgs.fetchurl {
      url = "https://i.imgur.com/IYEUudr.jpg";
      sha256 = "c8ea940104455d91543fa8d463e632c19a3a1f50c238c173099f6abbedd80025";
    };

    #image = pkgs.fetchurl {
    #  url = "https://i.imgur.com/OPojTrI.jpg";
    #  sha256 = "7cd9e59b85611b072178d25a87dea20d65a00666fdfd95e42ed4fb11afaac044";
    #};

    polarity = "dark";

    #base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    fonts =
      let
        jetBrainsMono = {
          package = pkgs.jetbrains-mono;
          name = "JetBrains Mono";
        };
      in
      {
        monospace = jetBrainsMono;
        serif = jetBrainsMono;
        sansSerif = jetBrainsMono;

        sizes = {
          desktop = 11;
        };
      };

    cursor = {
      package = pkgs.gnome3.adwaita-icon-theme;
      name = "Adwaita";
      size = 24;
    };

    targets = {
      nixvim.enable = false;
      fish.enable = false;
      fzf.enable = false;

      zathura.enable = true;
      kde.enable = false;
      gnome.enable = true;
      gtk.enable = true;

      waybar = {
        #customStyle = ../waybar/waybar.css;
      };
    };

    opacity = {
      applications = 0.9;
      popups = 0.9;
      terminal = 0.9;
      desktop = 0.9;
    };
  };
}
