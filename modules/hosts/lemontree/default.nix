{ self, inputs, ... }: {

  flake.nixosConfigurations.lemontree = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.lemontreeConfiguration
    ];
  };

}
