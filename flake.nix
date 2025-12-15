# flake.nix

{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } (top@{ config, withSystem, moduleWithSystem, ... }: {

      debug = true;

      imports = [];

      flake = {

        nixosConfigurations.lemontree = inputs.nixpkgs.lib.nixosSystem {
          modules = [

            ({ pkgs, ... }: {
              imports = [
                ./configuration.nix
              ];

              nixpkgs.config.allowUnfree = true;
              # nixpkgs.overlays = [ inputs.foo.overlays.default ];

              # services.foo.package = withSystem pkgs.stdenv.hostPlatform.system (
              #   { config, ... }:  # perSystem module arguments
              #   config.packages.bat
              # );
            })

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
