{ config, pkgs, inputs, ... }:

{
  users.users.nadaso8 = {
    isNormalUser = true;
    description = "Marceline Sorensen";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"  # Gives rights to manage wifi networks etc
      "wheel"           # Gives sudo rights
      "plugdev"         # Give usb access
      "dialout"         # Give serial access (/dev/tty*)
      "lp"              # Give access to network scanners
    ];
    packages = with pkgs; [
      # Chat
      discord
      signal-desktop

      # Study
      anki

      # Word processing 
      obsidian
      typst
      typstyle

      # Image editing
      krita
      inkscape

      # A/V toolchain
      pitivi
      mixxx

      # Accounting
      gnucash

      # Computing
      cbqn
      
      # IDE
      lldb
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions; [
          # debuggers
          vscode-extensions.ms-vscode.cpptools
          vscode-extensions.vadimcn.vscode-lldb
          vscode-extensions.bbenoist.nix
          vscode-extensions.rust-lang.rust-analyzer
          vscode-extensions.tamasfe.even-better-toml
          vscode-extensions.myriad-dreamin.tinymist
        ];
      })

      # Minecraft
      prismlauncher
    ];
    openssh.authorizedKeys.keys = [
      # Any ssh pubkeys that you want to give access to your account can go here
    ];
  };

  # Steam 
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };

}
