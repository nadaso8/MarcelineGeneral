{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Provides eachDefaultSystem and other utility functions
    flake-utils.url = "github:numtide/flake-utils";
    # Manages user settings
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, home-manager, ... }@inputs:
    let
      # All systems we may care about evaluating nixpkgs for
      systems = with flake-utils.lib.system; [ x86_64-linux aarch64-linux aarch64-darwin x86_64-darwin ];
      perSystem = (system: rec {
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            ((import overlays/nixpkgs-unstable.nix) { inherit inputs; })
          ];
          config = {
            allowUnfree = true;
          };
        };
      });
      # This `s` helper variable caches each system we care about in one spot.
      # For example, you can access `s.x86_64-linux.whatever`.
      inherit (flake-utils.lib.eachSystem systems (system: { s = perSystem system; })) s;
    in
    {
      # Please replace `nixos` with your hostname
      nixosConfigurations."Ainsworth" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # extra arguments to pass to configuration.nix
        specialArgs = {
          inherit system; # equivalent to system = system;
          hostname = "Ainsworth";
        };
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./Ainsworth/configuration.nix
          ./base.nix
          ./nadaso8.nix
          # home-manager manages your dotfiles and user environment.
          # https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nadaso8 = import ./home.nix;
            # These are extra arguments passed to home.nix
            home-manager.extraSpecialArgs = { username = "nadaso8"; };
          }
        ];
      };
      nixosConfigurations."Sebastian" = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        # extra arguments to pass to configuration.nix
        specialArgs = {
          inherit system; # equivalent to system = system;
          hostname = "Sebastian";
        };
        modules = [
          # Import the previous configuration.nix we used,
          # so the old configuration file still takes effect
          ./Sebastian/configuration.nix
          ./base.nix
          ./nadaso8.nix
          # home-manager manages your dotfiles and user environment.
          # https://nix-community.github.io/home-manager/index.xhtml#sec-flakes-nixos-module
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.nadaso8 = import ./home.nix;
            # These are extra arguments passed to home.nix
            home-manager.extraSpecialArgs = { username = "nadaso8"; };
          }
        ];
      };
    } // flake-utils.lib.eachSystem systems # the `//` operator merges the two sets
      (system:
        let
          inherit (s.${system}) pkgs inputs;
        in
        {
          # type `nix fmt` to autoformat your flake.
          formatter = pkgs.nixpkgs-fmt;
        }
      );
}
