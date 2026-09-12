{ self, inputs, ... }: {

  flake.nixosConfigurations.lemontree = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # Host-Specific Modules
      self.nixosModules.lemontreeConfiguration
      self.nixosModules.lemontreeHardware
      self.nixosModules.lemontreeVm
      self.nixosModules.userSyahn

      # Desktop Modules
      self.nixosModules.fonts
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.xdgPortals

      # Hardware Modules
      self.nixosModules.bluetooth
      self.nixosModules.amdApu

      # System Modules
      self.nixosModules.boot
      self.nixosModules.networking
      self.nixosModules.systemPackages

      # Services Modules
      self.nixosModules.openssh
      self.nixosModules.pipewire

    ];
  };
}
