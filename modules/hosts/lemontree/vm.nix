# modules/hosts/lemontree/vm.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.lemontreeVm =
  { config, lib, pkgs, ... }:
  {
    virtualisation = {
      libvirtd.enable = true;
      vmVariant = {
        users.users.vmuser = {
          isNormalUser = true;
          initialPassword = "password01";
          extraGroups = [ "wheel" ];
        };

        virtualisation = {
          memorySize = 4096;
          cores = 4;
          graphics = true;
          qemu.options = [
            "-vga virtio"
            "-display gtk,zoom-to-fit=on"
            "-chardev qemu-vdagent,id=ch1,name=vdagent,clipboard=on"
            "-device virtio-serial-pci"
            "-device virtserialport,chardev=ch1,id=ch1,name=com.redhat.spice.0"
          ];
        };
      };
    };
  };
}
