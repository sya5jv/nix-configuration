{ inputs, lib, ... }:
{
  flake.nixosModules.lemontreeLuks =
    { config, lib, pkgs, ... }:
    {
      boot = {
        initrd = {
          # Kernel modules on startup
          kernelModules = [
            "dm-snapshot" # dm-snapshot for btrfs CoW snapshots
            "cryptd"      # cryptd for LUKS encryption of disk
          ];

          # Enabling systemd at stage 1 for suspensions and hibernation on encryted disks
          systemd = {
            enable = true;
          };

          # Specifying which device is LUKS encrypted
          luks.devices = {
            luksroot = {
              device = "/dev/nvme0n1p2"; # TODO: Replace with UUID
              preLVM = true;
            };
          };
        }; # initrd
      }; # boot
    };
}
