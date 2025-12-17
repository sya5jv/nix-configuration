{
  description = "NixOS configuration";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, ... }: {

    nixosConfigurations.lemontree = nixpkgs.lib.nixosSystem {

      system = "x86_64-linux";

      modules = [
        ./configuration.nix
        # ./noctalia.nix
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            users.syahn = import ./home.nix;
            backupFileExtension = "backup";
          };
        };

      ];

    };
  };
}
