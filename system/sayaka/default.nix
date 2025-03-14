{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ../ollama
  ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # needed to unlock LUKS with key from TPM
  boot.initrd.systemd.enable = true;

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr
    rocmPackages.clr.icd
  ];
  nixpkgs.config.rocmSupport = true;
  # Force gfx900 which is the closest to my igpu (gfx90c)
  services.ollama.rocmOverrideGfx = "9.0.0";

  hardware.bluetooth.enable = true;

  services.fprintd = {
    enable = true;
  };

  # lanzaboote

  # This should already be here from switching to bootspec earlier.
  # It's not required anymore, but also doesn't do any harm.
  boot.bootspec.enable = true;

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = pkgs.lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
}
