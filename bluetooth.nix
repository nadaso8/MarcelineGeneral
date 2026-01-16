{ config, pkgs, hostname, system, inputs, ... }:
{
  hardware.bluetooth.enable = true;

  environment.systemPackages = [
    pkgs.bluetui
  ];
}
