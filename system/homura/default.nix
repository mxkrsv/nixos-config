{ pkgs, lib, ... }: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # needed to unlock LUKS with key from TPM
  boot.initrd.systemd.enable = true;

  # VAAPI and ROCm
  hardware.graphics = {
    extraPackages = with pkgs; [
      intel-media-driver
      rocmPackages.clr
      rocmPackages.clr.icd
    ];
  };
  nixpkgs.config.rocmSupport = true;

  # lanzaboote

  # Lanzaboote currently replaces the systemd-boot module.
  # This setting is usually set to true in configuration.nix
  # generated at installation time. So we force it to false
  # for now.
  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
}
