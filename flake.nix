{
  description = "A simple NixOS flake";

  inputs = {
    # NixOS official package source, using the nixos-24.11 branch here
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Provides eachDefaultSystem and other utility functions
    flake-utils.url = "github:numtide/flake-utils";
    # Manages user settings
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
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
            ((import ./overlays/nixpkgs-unstable.nix) { inherit inputs; })
          ];
          config = {
            allowUnfree = true;
          };
        };
      });
      # This `s` helper variable caches each system we care about in one spot.
      # For example, you can access `s.x86_64-linux.whatever`.
      inherit (flake-utils.lib.eachSystem systems (system: { s = perSystem system; })) s;

      nixosConfig = { system, username, hostname, modulePath, homeManagerCfg ? ./home.nix }: (
        let
          pkgs = s.${system}.pkgs;
        in
        inputs.nixpkgs.lib.nixosSystem rec{
          specialArgs = { inherit system username hostname inputs; };
          modules = [
            {
              nixpkgs = {
                inherit pkgs;
              };
            }

            modulePath

            inputs.home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                # include the home-manager module
                users.${username} = import homeManagerCfg;
                extraSpecialArgs = {
                  inherit username;
                };
              };
            }
          ];
        }
      );

    in
    {

      nixosConfigurations."Ainsworth" = nixosConfig {
        system = "x86_64-linux";
        username = "nadaso8";
        hostname = "Ainsworth";
        modulePath = ./Ainsworth/configuration.nix;
      };

      nixosConfigurations."Sebastian" = nixosConfig {
        system = "x86_64-linux";
        username = "nadaso8";
        hostname = "Sebastian";
        modulePath = ./Sebastian/configuration.nix;
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
