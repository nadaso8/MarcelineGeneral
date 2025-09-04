{ config, pkgs, hostname, inputs, ... }:

{
  # Features
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Add NTFS
  boot.supportedFilesystems = [ "ntfs" ];

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
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

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

  # Create plugdev group
  users.groups = {
    plugdev = { };
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

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

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

    # Web Browsers
    firefox

    # Version Controll
    git

    # System Utilities
    lshw
    usbutils
    bottom

    # Text Editors 
    neovim
    helix
  ];
}
