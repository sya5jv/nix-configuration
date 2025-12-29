{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = inputs@{ 
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    # ghostty,
    ...
  }: {

    nixosConfigurations.lemontree = nixpkgs.lib.nixosSystem {

      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

      modules = [

        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.syahn = import ./home.nix;
            backupFileExtension = "backup";
          };
        }

        nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5

      ];

    };
  };
}
