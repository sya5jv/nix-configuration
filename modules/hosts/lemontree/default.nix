{ self, inputs, ... }: {

  flake.nixosConfigurations.lemontree = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # self.nixosModules.lemontreeConfiguration
      self.nixosModules.lemontree-hardware
      self.nixosModules.lemontree-vm
      self.nixosModules.firmware
      self.nixosModules.amd-apu
      self.nixosModules.boot
      self.nixosModules.networking
      self.nixosModules.users
      self.nixosModules.openssh

    {
      networking.hostName = "lemontree";
      system.stateVersion = "25.11";
    }

    ];

  };

}
