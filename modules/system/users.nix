# modules/system/users.nix
# Temporary place to define the main system user for now.

{ inputs, lib, ... }:
{
  flake.nixosModules.users =
  { config, lib, pkgs, ... }:
  {
    users.users.syahn = {
      isNormalUser = true;
      home = "/home/syahn";
      uid = 1000;
      extraGroups = [
        "wheel"
        "rtkit" # Pipewire "RealtimeKit"
        "networkmanager"
        "tss" # TPM access system group
      ];
      shell = pkgs.fish;
    };
    programs.fish.enable = true;
  };
}
