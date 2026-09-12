# modules/hardware/amd/apu.nix
# Module for AMD's Accelerated Processing Units

{ self, inputs, lib, ... }:
{
  flake.nixosModules.amdApu =
    { config, lib, pkgs, ... }:
    {
      imports = [
        self.nixosModules.amdCpu
        self.nixosModules.amdGraphics
      ];
    };
}
