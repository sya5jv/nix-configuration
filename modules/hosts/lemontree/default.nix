# modules/hosts/lemontree/default.nix
# Main "entrypoint" for the host.
{
  self,
  inputs,
  ...
}:
{
  flake.nixosConfigurations.lemontree = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      # Host-Specific Modules
      self.nixosModules.lemontreeConfiguration
      self.nixosModules.lemontreeHardware
      self.nixosModules.lemontreeVm
      self.nixosModules.lemontreeLuks
      self.nixosModules.userSyahn

      # Desktop Modules
      self.nixosModules.fonts
      self.nixosModules.niri
      self.nixosModules.noctalia
      self.nixosModules.xdgPortals
      self.nixosModules.gnomeRemoteDesktop

      # Hardware Modules
      self.nixosModules.commonHardwareConfig
      self.nixosModules.bluetooth
      self.nixosModules.amdApu

      # Profiles
      self.nixosModules.laptopConfiguration

      # System Modules
      self.nixosModules.boot
      self.nixosModules.networking
      self.nixosModules.systemPackages
      self.nixosModules.power

      # Services Modules
      self.nixosModules.fwupd
      self.nixosModules.gnomeKeyring
      self.nixosModules.openssh
      self.nixosModules.fail2ban
      self.nixosModules.pipewire

      # Security Modules
      self.nixosModules.pam
      self.nixosModules.polkit
      self.nixosModules.tpm2
    ];
  };
}
