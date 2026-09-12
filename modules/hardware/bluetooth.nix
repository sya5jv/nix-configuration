# modules/hardware/bluetooth.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.bluetooth =
  { config, pkgs, lib, ... }:
  {
    hardware.bluetooth.enable = true;
  };
}
