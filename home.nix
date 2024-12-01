{ pkgs, lib, username, ... }:
let
  inherit (pkgs.stdenv) isDarwin;
  inherit (pkgs.stdenv) isLinux;
in
{
  home = {
    username = "${username}";
    homeDirectory = if isDarwin then "/Users/${username}" else "/home/${username}";
    packages = [ ];
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
    shellAliases = { };
  };

  programs.home-manager.enable = true;
  programs.git = {
    enable = true;
    userName = "nadaso8";
    userEmail = "nadaso8@gmail.com";
    lfs.enable = true;
    extraConfig = {
      rebase = {
        updateRefs = true;
      };
    };
  };

  # shell stuff
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    enableCompletion = true;
    oh-my-zsh.enable = true;
    initExtra = ''
      set -o vi
    '';
    envExtra = ''
    '';
  };
  programs.starship = {
    enable = true;
    # settings = lib.trivial.importTOML ./xdg/starship.toml;
    settings = lib.trivial.importTOML ./xdg/starship-no-nerd-font.toml;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true; # see note on other shells below
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  xdg.enable = true;
  xdg.configFile = {
    # "nvim" = {
    #   source = pkgs.fetchFromGitHub {
    #     owner = "thebutlah";
    #     repo = "init.lua";
    #     rev = "747af1a9072ddf50a0d7af3db73c4462c74bbc73";
    #     hash = "sha256-jNsdrLzHlLsKGeulXA833aynL2pwYkJWM2tpzo8XLCQ=";
    #   };
    # };
  };

  fonts.fontconfig.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # programs.keychain = {
  #   enable = true;
  #   keys = [ "id_ed25519" ];
  # };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
