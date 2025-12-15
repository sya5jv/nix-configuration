{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    nixosConfigurations = {
      lemontree = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/lemontree/configuration.nix   # Allows flakes to organize configuration of modules by host
          inputs.home-manager.nixosModules.default
          nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
        ];
      };

      # # If you want to add another host
      # host02 = nixpkgs.lib.nixosSystem {
      #   specialArgs = {inherit inputs;};
      #   modules = [
      #     ./hosts/host02/configuration.nix
      #     inputs.home-manager.nixosModules.default
      #     nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
      #   ];
      # };
    };
  };
}
