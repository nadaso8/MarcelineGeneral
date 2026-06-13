{ config, pkgs, hostname, inputs, ... }: {
  services.xserver.enable = true;
  programs.xwayland.enable = true;
  services.displayManager.sddm.enable = true;
  programs.niri.enable = true;
  #include plasma 6 as a fallback for when applications don't play nicely with niri.
  services.desktopManager.plasma6.enable = true;

  environment.sessionVariables.NIRI_CONFIG = "~/MarcelineGeneral/.config/niri/config.kdl"
}
