{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  networking.hostName = "sayaka";

  hardware.opengl.extraPackages = with pkgs; [
    rocm-opencl-icd
    rocm-opencl-runtime
  ];

  services.fprintd = {
    enable = true;
  };

  security.pam.services = {
    # somewhy required
    #swaylock.fprintAuth = true;
    swaylock.text = ''
      # Account management.
      account required pam_unix.so

      # Authentication management.
      auth sufficient pam_unix.so   likeauth try_first_pass
      auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
      auth required pam_deny.so

      # Password management.
      password sufficient pam_unix.so nullok yescrypt

      # Session management.
      session required pam_env.so conffile=/etc/pam/environment readenv=0
      session required pam_unix.so
    '';

    # slightly more security
    greetd.fprintAuth = false;
    login.fprintAuth = false;
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
      PLATFORM_PROFILE_ON_BAT = "balanced";

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
