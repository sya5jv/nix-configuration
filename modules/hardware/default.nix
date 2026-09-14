# modules/hardware/common.nix

# This file acts as a commonly sourced hardware configuration file for all hosts.
# Host-specific hardware still managed by hardware.nix within each host directory.

{ inputs, lib, ... }:
{
  flake.nixosModules.commonHardwareConfig =
  { config, pkgs, lib, ... }:
  {
    hardware.enableRedistributableFirmware = lib.mkDefault true;
  };
}
