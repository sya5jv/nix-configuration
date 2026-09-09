# modules/system/boot.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.boot =
    { config, lib, pkgs, ... }:
    {
      boot = {
        kernelPackages = pkgs.linuxPackages_latest;
        loader = {
          # systemd-boot.enable = true; # Turned off 
          limine.enable = true;
          efi.canTouchEfiVariables = true;
        };
      };
    };
}
