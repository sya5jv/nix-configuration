# modules/services/pipewire.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.pipewire =
  { config, pkgs, lib, ... }:
  {
    services.pipewire = {
      enable = true;
      pulse.enable = true;
    };
  };
}
