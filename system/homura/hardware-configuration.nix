# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/f64ab27f-eac0-41f3-a6d5-d4bab33c80d1";
      fsType = "btrfs";
      options = [ "subvol=root" "compress=zstd" "noatime" ];
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/228a3c5e-7842-460e-84b6-46d72991825e";

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/f64ab27f-eac0-41f3-a6d5-d4bab33c80d1";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd" "noatime" ];
    };

  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/f64ab27f-eac0-41f3-a6d5-d4bab33c80d1";
      fsType = "btrfs";
      options = [ "subvol=nix" "compress=zstd" "noatime" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/CED7-E82B";
      fsType = "vfat";
    };

  boot.initrd.luks.devices."cryptdata".device = "/dev/disk/by-uuid/130623b9-d6bc-41d2-9e29-5efb35073ca9";

  fileSystems."/home/mxkrsv/data" =
    {
      device = "/dev/disk/by-uuid/fdb02358-2703-435c-80ab-0a2ebf642d80";
      fsType = "btrfs";
      options = [ "subvol=data" "compress=zstd" "noatime" ];
    };

  fileSystems."/home/mxkrsv/code" =
    {
      device = "/dev/disk/by-uuid/fdb02358-2703-435c-80ab-0a2ebf642d80";
      fsType = "btrfs";
      options = [ "subvol=code" "compress=zstd" "noatime" ];
    };

  fileSystems."/home/mxkrsv/Music" =
    {
      device = "/dev/disk/by-uuid/fdb02358-2703-435c-80ab-0a2ebf642d80";
      fsType = "btrfs";
      options = [ "subvol=music" "compress=zstd" "noatime" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp0s31f6.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
