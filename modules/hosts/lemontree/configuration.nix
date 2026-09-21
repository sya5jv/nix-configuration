# modules/hosts/lemontree/configuration.nix
# TODO: Split this out into more modules.
{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.lemontreeConfiguration =
    {
      pkgs,
      lib,
      ...
    }:
    {
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      fileSystems = {
        "/".options = [ "compress=zstd" ];
        "/home".options = [ "compress=zstd" ];
        "/nix".options = [
          "compress=zstd"
          "noatime"
        ];
      };

      time.timeZone = "America/New_York";

      services = {
        fprintd.enable = false;

        # BTRFS automatic data integrity checking
        btrfs.autoScrub = {
          enable = false;
          interval = "monthly";
          fileSystems = [ "/" ];
        };

        # Allow users to SSH onto machine
        openssh.settings.AllowUsers = [ "syahn" ];

        getty.autologinUser = null;
      };

      networking.hostName = "lemontree";

      system.stateVersion = "25.11";
    };
}
