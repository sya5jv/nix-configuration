# nixos.nix

{ withSystem, inputs, ... }: {

  perSystem = { system, ... }: {

    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;
      overlays = [ inputs.foo.overlay.default ];
      config = {
        allowUnfree = true;
      };
    };

  };

  flake = {

    nixosConfigurations.lemontree = inputs.nixpkgs.lib.nixosSystem {

      modules = [

        ./configuration.nix
        inputs.nixpkgs.nixosModules.readOnlyPkgs

        ({ config, ... }: {
          # Use the configured pkgs from perSystem
          nixpkgs.pkgs = withSystem config.nixpkgs.hostPlatform.system (
            { pkgs, ... }:
            pkgs
          );
        })

      ];

    };

  };

}
