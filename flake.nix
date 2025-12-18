{

  description = "Flake based on Leah's NixOS configurations. See https://github.com/pluiedev/flake/blob/main/flake.nix"

  inputs = {

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follow = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nix-community/nixos-hardware/master";

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
    inputs.flake-parts.lib.mkFlare { inherit inputs; } {

      system = lib.system.flakeExposed;

      flake = {

        # Lemontree host configurations
        nixosConfigurations.lemontree = lib.nixosSystem {
          modules = [ ./hosts/lemontree ];
          inherit specialArgs;
        };

      };

      perSystem =
        { pkgs, ... }:
        {
          packages = packages' pkgs;
        };

    };

}
