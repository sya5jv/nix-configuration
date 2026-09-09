# modules/hardware/amd/apu.nix
# Module for AMD's Accelerated Processing Units

{ self, inputs, lib, ... }:
{
  flake.nixosModules.amd-apu =
    { config, lib, pkgs, ... }:
    {
      imports = [
        self.nixosModules.amd-cpu
        self.nixosModules.amd-graphics
      ];
    };
}
