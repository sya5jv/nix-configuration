# modules/hardware/amd/cpu.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.amd-cpu =
  { config, lib, pkgs, ... }:
  {
    hardware.cpu.amd.updateMicrocode = lib.mkDefault true;
  };
}
