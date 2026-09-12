# modules/hardware/amd/cpu.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.amdCpu =
  { config, lib, pkgs, ... }:
  {
    hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
  };
}
