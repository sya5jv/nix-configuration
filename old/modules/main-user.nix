# main-user.nix

{ lib, config, pkgs, ... }:

let
  cfg = config.main-user;
in
{
  options.main-user = {
    enable = lib.mkEnableOption "enable user module";

    username = lib.mkOption {
      default = "mainuser";
      description = ''
        username
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.${cfg.username} = {
      isNormalUser = true;
      initialPassword = "1234";
      description = "This is the main user account.";
      shell = pkgs.fish;
      home = "/home/${cfg.username}";
      uid = 1000;
      group = "users";
      extraGroups = [
        "wheel"
        "networkmanager"
        "tss"
      ];
    };
  };
}
