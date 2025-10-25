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
  
  # Enable networking
  networking.hostName = hostname;
  networking.networkmanager.enable = true;
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

    # Desktop Utils TODO: break this out into niri.nix? 
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
    google-chrome

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
