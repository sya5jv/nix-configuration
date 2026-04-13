{ config, lib, ... }:
{

  imports = [
    ../common.nix
    ./programs
  ];

  users.users.syahn = {
    enable = lib.mkDefault false;   # Machines must manually enable the users
    isNormalUsers = true;
    description = "Sam Ahn";
    uid = 1000;
    group = "users";
    extraGroups = [
      "wheel"
      "rtkit"
      "networkmanager"
      "tss"
    ];

    packages = config.hjem.users.syahn.packages;
  };

  hjem.users.syahn.enable = true;

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

}
