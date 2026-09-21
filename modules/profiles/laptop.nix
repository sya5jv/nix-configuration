# modules/profiles/laptop.nix
{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.laptopConfiguration =
    { lib, ... }:
    {
      services = {
        # logind Laptop Lid Settings
        logind.settings.Login = {
          HandleLidSwitch = lib.mkDefault "suspend";
          HandleLidSwitchExternalPower = lib.mkDefault "suspend";
          HandleLidSwitchDocked = lib.mkDefault "ignore";
        };

        # Enable Touchpad Support
        libinput.enable = true;
      };
    };
}
