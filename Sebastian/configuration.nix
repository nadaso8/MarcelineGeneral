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
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.groups = {
    plugdev = { };
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
