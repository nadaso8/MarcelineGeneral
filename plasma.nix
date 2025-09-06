{ config, pkgs, hostname, inputs, ... } : {
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}