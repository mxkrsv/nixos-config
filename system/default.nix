{ lib, pkgs, inputs, ... }: {
  imports = [
    ./secrets.nix
    ./sing-box.nix
  ];

  nix = {
    # make nix3 commands consistent with the flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';

    settings = {
      auto-optimise-store = true;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  networking = {
    # Pick only one of the below networking options.
    # wireless.enable = true;
    networkmanager.enable = true;

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];

    # I play CTF
    firewall.enable = false;

    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  # Set your time zone.
  time.timeZone = "Europe/Moscow";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "us";
    # useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  hardware.graphics.enable = true;

  # Enable sound.
  # No real need to save the state on reboot
  #sound.enable = true;
  hardware.pulseaudio.enable = false;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mxkrsv = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "video"
      "audio"
      "networkmanager"
      "adbusers"
      "wireshark"
      "docker"
      "dialout"
    ];
    shell = pkgs.fish;
  };

  # List services that you want to enable:
  services = {
    # Enable the OpenSSH daemon.
    openssh.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.gcr ];
    };

    #greetd = {
    #  enable = true;
    #  settings = {
    #    default_session = {
    #      command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd sway";
    #      user = "greeter";
    #    };
    #  };
    #  vt = 7;
    #};

    fwupd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };
  };

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
  system.stateVersion = "23.05"; # Did you read the comment?

  boot.kernelPackages = pkgs.linuxPackages_latest;

  environment.defaultPackages = [ ];

  environment.systemPackages = with pkgs; [
    # system
    linuxPackages_latest.cpupower
    openssl
    glib # gsettings
    man-pages
    man-pages-posix
    sbctl # secure boot keys
    wayland

    # essential system utils
    htop
    wget
    tmux
    inetutils
    dig
    pciutils
    usbutils

    # non-essential programs
    pulsemixer
    git
    xdg-utils
    wl-clipboard
    neovim

    # for virtiofs in virt-manager
    virtiofsd
  ];

  # xdg-desktop-portal (screen sharhing, file choosing, etc.)
  #xdg.portal = {
  #  enable = true;

  #  wlr.enable = true;
  #  configPackages = with pkgs; [
  #    xdg-desktop-portal-wlr
  #  ];

  #  # gtk portal needed to make gtk apps happy
  #  extraPortals = with pkgs; [
  #    xdg-desktop-portal-gtk
  #    xdg-desktop-portal-kde
  #  ];
  #};

  security = {
    polkit.enable = true;

    sudo.enable = true;

    # Fix swaylock
    pam.services.swaylock = { };

    # Needed for PipeWire
    rtkit.enable = true;
  };

  programs = {
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;

    light.enable = true;

    zsh.enable = true;
    fish.enable = true;

    dconf.enable = true;

    #kdeconnect.enable = true;

    adb.enable = true;

    wireshark.enable = true;

    virt-manager.enable = true;
  };

  virtualisation = {
    #podman.enable = true;
    docker = {
      enable = true;

      daemon.settings = {
        registry-mirrors = [
          "https://mirror.gcr.io"
        ];
      };
    };

    libvirtd = {
      enable = true;
    };
  };

  # Allow root to edit hosts directly (will reset after system rebuild)
  environment.etc.hosts.mode = "0644";

  # Enable ucode updates
  hardware.enableRedistributableFirmware = true;

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  nixpkgs.overlays = [
    # triple-buffering-v4-46 branch
    (final: prev: {
      gnome = prev.gnome.overrideScope (gnomeFinal: gnomePrev: {
        mutter = gnomePrev.mutter.overrideAttrs (old: {
          src = pkgs.fetchFromGitLab {
            domain = "gitlab.gnome.org";
            owner = "vanvugt";
            repo = "mutter";
            rev = "0d46de978d3dccc3784ba1902cbd9dada61d8a86";
            hash = "sha256-nz1Enw1NjxLEF3JUG0qknJgf4328W/VvdMjJmoOEMYs=";
          };
        });
      });
    })
  ];

  services.power-profiles-daemon.enable = false;

  # Fancy boot splash screen
  boot.plymouth.enable = true;
}
