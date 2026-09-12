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
        # Device hibernation
        # resumeDevice = "/dev/dm-1";  # WIP: Need to look at TPM in order to look at automatic device unlocking
      };
    };
}
