# flake.nix

{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, flake-parts, home-manager, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (top@{ config, withSystem, moduleWithSystem, ... }: {

      debug = true;

      imports = [
        inputs.home-manager.flakeModules.home-manager
      ];

      flake = {

        nixosConfigurations.lemontree = inputs.nixpkgs.lib.nixosSystem {
          modules = [

            ({ pkgs, ... }: {
              imports = [
                ./hosts/lemontree/configuration.nix
              ];

              nixpkgs.config.allowUnfree = true;
              # nixpkgs.overlays = [ inputs.foo.overlays.default ];

              # services.foo.package = withSystem pkgs.stdenv.hostPlatform.system (
              #   { config, ... }:  # perSystem module arguments
              #   config.packages.bat
              # );
            })

            home-manager.nixosModules.home-manager {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              home-manager.users.syahn = import ./home.nix;
            }

          ];
        };

      };

      systems = [ "x86_64-linux" ];

      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = pkgs.hello;
      };

    });
}

# Helpful documentation from flake-parts flake template
#
# flake-parts imports
#
# To import an internal flake module: ./other.nix
# To import an external flake module:
#   1. Add foo to inputs
#   2. Add foo as a parameter to the outputs function
#   3. Add here: foo.flakeModule
#
#
# flake-parts flake
#
# The usual flake attributes can be defined here, including system-
# agnostic ones like nixosModule and system-enumerating ones, although
# those are more easily expressed in perSystem.
#
#
# flake-parts systems
#
# systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
#
#
# flake-parts perSystem
#
# Per-system attributes can be defined here. The self' and inputs'
# module parameters provide easy access to attributes of the same
# system.
#
# Equivalent to  inputs'.nixpkgs.legacyPackages.hello;
