# modules/users/common.nix
# This module serves as a way to define common settings across all users to stay DRY.

{ inputs, lib, ... }:
{
  flake.lib.mkUser = username:
    { config, lib, pkgs, ... }:
    {
      imports = [ inputs.hjem.nixosModules.hjem ];

      # Setting clobbering as false to avoid accidental overwriting
      hjem.clobberByDefault = lib.mkDefault false;

      users.users.${username} = {
        isNormalUser = true;
      };

      # For the rare case that the NixOS user is imported, but hjem shouldn't be enabled
      hjem.users.${username}.enable = lib.mkDefault true;
    };
}
