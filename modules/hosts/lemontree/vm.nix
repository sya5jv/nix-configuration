# modules/hosts/lemontree/vm.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.lemontreeVm =
  { config, lib, pkgs, ... }:
  {
    virtualisation.vmVariant = {
      users.users.vmuser = {
        isNormalUser = true;
        initialPassword = "password01";
        extraGroups = [ "wheel" ];
      };

      virtualisation.memorySize = 4096;
      virtualisation.core = 4;
    };
  };
}
