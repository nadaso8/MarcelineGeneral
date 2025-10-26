# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, hostname, system, inputs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../base.nix
      ../nadaso8.nix
      ../niri.nix
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
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  services.xserver.videoDrivers = [ "nvidia" ];

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

  environment.systemPackages = with pkgs; [
    brightnessctl
    #unstable.omnissa-horizon-client
  ];

  # This setups a SSH server for remote access.
  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
