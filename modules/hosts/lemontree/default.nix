{ self, inputs, ... }: {

  flake.nixosConfigurations.lemontree = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # self.nixosModules.lemontreeConfiguration
      self.nixosModules.lemontreeHardware
      self.nixosModules.lemontreeVm
      self.nixosModules.firmware
      self.nixosModules.amdApu
      self.nixosModules.boot
      self.nixosModules.networking
      self.nixosModules.userSyahn
      self.nixosModules.openssh

    {
      networking.hostName = "lemontree";
      system.stateVersion = "25.11";
    }

    ];

  };

}
