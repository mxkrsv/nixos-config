{ pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  #boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # Secureboot
  #boot.bootspec.enable = true;
  #boot.loader.systemd-boot.enable = lib.mkForce false;
  #boot.lanzaboote = {
  #  enable = true;
  #  pkiBundle = "/etc/secureboot";
  #};

  networking.hostName = "sayaka";

  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    extraPackages = with pkgs; [
      rocm-opencl-icd
      rocm-opencl-runtime
    ];
  };

  hardware.usbWwan.enable = true;

  # Enable sound.
  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  hardware.bluetooth.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mxkrsv = {
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "adbusers" "wireshark" ];
    shell = pkgs.zsh;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.systemPackages = with pkgs; [
    linuxPackages_latest.cpupower
    openssl
    pulsemixer
    htop
    wayland
    xdg-utils
    glib # gsettings
    gnome3.adwaita-icon-theme
    wl-clipboard
    neovim
    wget
    gopass
    man-pages
    man-pages-posix
    tmux
    git
    sbctl # secure boot keys
  ];

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  # xdg-desktop-portal works by exposing a series of D-Bus interfaces
  # known as portals under a well-known name
  # (org.freedesktop.portal.Desktop) and object path
  # (/org/freedesktop/portal/desktop).
  # The portal interfaces include APIs for file access, opening URIs,
  # printing and others.
  services.dbus.enable = true;
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    # gtk portal needed to make gtk apps happy
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  # enable sway window manager
  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #};

  programs.light.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
    vt = 7;
  };

  programs.zsh.enable = true;
  programs.fish.enable = true;

  fonts = {
    fonts = with pkgs; [
      font-awesome
      jetbrains-mono
      dejavu_fonts
    ];
  };

  security.polkit.enable = true;

  security.sudo.enable = true;

  security.doas = {
    enable = true;
    extraRules = [
      {
        groups = [ "wheel" ];
        persist = true;
      }
    ];
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

  environment.defaultPackages = [ ];

  services.fprintd = {
    enable = true;
  };

  programs.dconf.enable = true;

  security.pam.services = {
    # somewhy required
    swaylock.fprintAuth = true;
    # slightly more security
    greetd.fprintAuth = false;
  };

  services.fwupd.enable = true;

  virtualisation = {
    podman.enable = true;
  };

  programs.kdeconnect.enable = true;

  programs.adb.enable = true;

  programs.wireshark.enable = true;

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

  # allow root to edit hosts directly (will reset after system rebuild)
  environment.etc.hosts.mode = "0644";

  networking.firewall.enable = false;
}
