# modules/services/display-manager.nix
{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.displayManager =
    {
      config,
      pkgs,
      lib,
      ...
    }:
    {
      services.displayManager = {
        # ly = {
        #   enable = false;
        #   settings = {
        #     battery_id = "BAT0";
        #     brightness_up_cmd = "brightnessctl -q -n s 5%+";
        #     brightness_down_cmd = "brightnessctl -q -n s 5%-";
        #     clear_password = true;
        #     clock = "%c";
        #     default_input = "password";
        #     save = true;
        #     vi_mode = true;
        #     vi_default_mode = "insert";
        #   };
        # };

        noctalia-greeter = {
          enable = true;
          settings = {
            cursor = {
              theme = "Bibata-Modern-Ice";
              size = 24;
              path = "${pkgs.bibata-cursors}/share/icons";
            };
          };
        };

        autoLogin.enable = false;
      };
    };
}
