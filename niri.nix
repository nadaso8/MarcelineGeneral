{ config, pkgs, hostname, inputs, ... } : {
  services.xserver.enable = true;
  programs.xwayland.enable = true;
  services.displayManager.sddm.enable = true;
  programs.niri.enable = true;
  services.desktopManager.plasma6.enable = true;


  # Fix Electron apps in Niri
  # environment.sessionVariables.NIXOS_OZONE_WL = "1";
}