# modules/hardware/amd/graphics.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.amd-graphics =
    { config, lib, pkgs, ... }:
    {
      hardware.graphics.enable = true;
      hardware.graphics.enable32bit = true;

      # Option to disable Panel Self Refresh, a power-saving negotiation feature known to occasionally cause flickering
      # due to issues with the PSR driver
      # boot.kernelParams = [ "amdgpu.dcdebugmask=0x10" ]; # AMD Display Core (DC)
    };
}
