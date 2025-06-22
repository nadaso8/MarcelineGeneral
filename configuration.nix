# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hostname, system, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Add NTFS
  boot.supportedFilesystems = [ "ntfs" ];

  # Add Swap
  swapDevices = [{
    device = "/var/lib/swapfile";
    size = 32 * 1024;
  }];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  # Nvidia Drivers
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    amdgpuBusId = "PCI:4:0:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # AMD Drivers
  boot.initrd.kernelModules = [ "amdgpu" ];

  # Desktop
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Tiling Window Manager
  programs.niri.enable = true;
  # Fix X11 apps in Niri
  programs.xwayland.enable = true;
  # Fix Electron apps in Niri
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Audio
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
  };

  networking.hostName = hostname; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.wireless.secretsFile = "/run/secrets/wireless.conf";
  networking.wireless.networks = {
    "In-flight WiFi" = {
      pskRaw = "ext:psk_allie";
    };
    "Nadaso8" = {
      pskRaw = "ext:psk_home";
    };
    "Le Corbusier" = {
      pskRaw = "ext:psk_phone";
    };
  };
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Enable printing
  services.printing = {
    enable = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };



  # Set your time zone.
  time.timeZone = "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Configure keymap in X11
  services.xserver = {
    xkb.layout = "us";
    xkb.variant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups = {
    plugdev = { };
  };
  users.users.nadaso8 = {
    isNormalUser = true;
    description = "Marceline Sorensen";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager" # Gives rights to manage wifi networks etc
      "wheel" # Gives sudo rights
      "plugdev" # give usb access
      "dialout" # give serial access (/dev/tty*)
    ];
    packages = with pkgs; [
      # chat
      discord

      # notes/word processing 
      obsidian

      # image editing
      krita
      inkscape

      # A/V toolchain
      pitivi
      mixxx
    ];
    openssh.authorizedKeys.keys = [
      # Any ssh pubkeys that you want to give access to your account can go here
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [

    # Desktop Utils
    anyrun
    swaylock
    swww
    mako
    waybar
    xwayland-satellite

    # Terminal Emulators
    alacritty

    # Web
    firefox

    # General Development
    git

    # System Utilities
    lshw
    usbutils

    # IDE
    neovim
    helix
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        vscode-extensions.ms-vscode.cpptools
        vscode-extensions.bbenoist.nix
        vscode-extensions.rust-lang.rust-analyzer
        vscode-extensions.tamasfe.even-better-toml
      ];
    })
  ];

  # Steam 
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

  # Sunshine 
  services.sunshine = {
    enable = true;
    autoStart = false;
    capSysAdmin = true;
    openFirewall = true;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # This setups a SSH server for remote access.
  services.openssh = {
    enable = true;
    settings = {
      # Opinionated: forbid root login through SSH.
      PermitRootLogin = "no";
      # Opinionated: use keys only.
      # Remove if you want to SSH using passwords
      PasswordAuthentication = false;
    };
  };

  # USB stuff
  services.udev = {
    enable = true;
    # gives access to usb for all users in plugdev group
    extraRules = ''
      SUBSYSTEM=="usb", MODE="0660", GROUP="plugdev"
    '';
  };

  programs.zsh.enable = true;
  # Better compatibility with non-nixos programs:
  # https://github.com/nix-community/nix-ld
  programs.nix-ld.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
