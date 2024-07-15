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
  # Force gfx1030 which is the closest to my RX 6400 (gfx1034)
  services.ollama.rocmOverrideGfx = "10.3.0";

  hardware.bluetooth.enable = true;

  services.fprintd = {
    enable = true;
  };

  security.pam.services = {
    #swaylock.text = ''
    #  # Account management.
    #  account required pam_unix.so

    #  # Authentication management.
    #  auth sufficient pam_unix.so   likeauth try_first_pass
    #  auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
    #  auth required pam_deny.so

    #  # Password management.
    #  password sufficient pam_unix.so nullok yescrypt

    #  # Session management.
    #  session required pam_env.so conffile=/etc/pam/environment readenv=0
    #  session required pam_unix.so
    #'';

    ## slightly more security
    #greetd.fprintAuth = false;
    #login.fprintAuth = false;
  };

  services.tlp = {
    enable = true;
    settings = {
      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

      # amd-pstate=active
      CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "power";

      PLATFORM_PROFILE_ON_AC = "balanced";
      PLATFORM_PROFILE_ON_BAT = "low-power";

      RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
      RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
    };
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
    pkiBundle = "/etc/secureboot";
  };
}
