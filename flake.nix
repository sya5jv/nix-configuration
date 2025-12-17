{
  description = "NixOS configuration";

  inputs = {

    nixpkgs.url = "nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty.url = "github:ghostty-org/ghostty";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.quickshell.follows = "quickshell";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

  };

  outputs = inputs@{ 
    self,
    nixpkgs,
    home-manager,
    nixos-hardware,
    ghostty,
    ...
  }: {

    nixosConfigurations.lemontree = nixpkgs.lib.nixosSystem {

      system = "x86_64-linux";

      specialArgs = { inherit inputs; };

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
        }

        ({ pkgs, ... }: {
          environment.systemPackages = [
            ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
          ];
        })

        nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5

      ];

    };
  };
}
