{

  description = "Flake based on Leah's NixOS configurations. See https://github.com/pluiedev/flake/blob/main/flake.nix";

  inputs = {

    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
    };

    # nix-index-database = {
    #   url = "github:nix-community/nix-index-database";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

  };

  outputs =
    inputs:
    let
      inherit (inputs.nixpkgs) lib;
      packages' =
        pkgs':
        pkgs'.lib.packagesFromDirectoryRecursive {
          inherit (pkgs') callPackages;
          directory = ./packages;
        };
      specialArgs = { inherit inputs; };
    in
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {

      systems = lib.systems.flakeExposed;

      flake = {

        # Lemontree host configurations
        nixosConfigurations.lemontree = lib.nixosSystem {
          modules = [ ./hosts/lemontree ];
          inherit specialArgs;
        };

      };

      # perSystem =
      #   { pkgs, ... }:
      #   {
      #     packages = packages' pkgs;
      #   };

    };

}
