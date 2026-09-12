# modules/services/display-manager.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.displayManager =
  { config, pkgs, lib, ... }:
  {
    services.displayManager = {
      ly = {
        enable = false;
        settings = {
          battery_id = "BAT0";
          brightness_up_cmd = "brightnessctl -q -n s 5%+";
          brightness_down_cmd = "brightnessctl -q -n s 5%-";
          clear_password = true;
          clock = "%c";
          default_input = "password";
          save = true;
          vi_mode = true;
          vi_default_mode = "insert";
        };
      };
      autoLogin.enable = false;
    };
  };
}
