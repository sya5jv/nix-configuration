# modules/users/syahn/syahn.nix

{ self, inputs, lib, ... }:
{
  flake.nixosModules.userSyahn =
  { config, lib, ... }:
  {
    imports = [ (self.lib.mkUser "syahn") ];

    users.users.syahn = {
      description = "Samuel Ahn, syahn@proton.me";
      uid = 1000;
      group = "users";
      extraGroups = [
        "wheel"
        "rtkit"
        "networkmanager"
        "tss"
        "libvirtd"
      ];
      # shell = pkgs.fish;
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
    };
  };
}
