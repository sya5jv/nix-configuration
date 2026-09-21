# modules/hosts/lemontree/hardware.nix
{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.lemontreeHardware =
    {
      config,
      lib,
      pkgs,
      modulesPath,
      ...
    }:
    {
      imports = [
        (modulesPath + "/installer/scan/not-detected.nix")
      ];

      boot = {
        initrd = {
          availableKernelModules = [
            "nvme"
            "xhci_pci"
            "thunderbolt"
            "usb_storage"
            "sd_mod"
          ];
          kernelModules = [ "dm-snapshot" ];
        };

        kernelModules = [ "kvm-amd" ];
        extraModulePackages = [ ];
      };

      fileSystems = {
        "/" = {
          device = "/dev/mapper/nixos--vg-root";
          fsType = "btrfs";
          options = [ "subvol=root" ];
        };

        "/nix" = {
          device = "/dev/mapper/nixos--vg-root";
          fsType = "btrfs";
          options = [ "subvol=nix" ];
        };

        "/home" = {
          device = "/dev/mapper/nixos--vg-root";
          fsType = "btrfs";
          options = [ "subvol=home" ];
        };

        "/boot" = {
          device = "/dev/disk/by-uuid/61A4-99A1";
          fsType = "vfat";
          options = [
            "fmask=0077"
            "dmask=0077"
          ];
        };
      };

      swapDevices = [
        { device = "/dev/mapper/nixos--vg-swap"; }
      ];

      nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
      hardware.enableRedistributableFirmware = true;
    };
}
