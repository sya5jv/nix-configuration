{ config, lib, ... }: {

  imports = [
    ./appearance.nix
    ./programs
  ];

  users.users.syahn = {
    isNormalUser = true;
    description = "Sam Ahn";
    home = "/home/syahn";
    uid = 1000;
    group = "users";
    extraGroups = [
      "wheel"
      "networkmanager"
      "rtkit"
      "tss"
    ];
    shell = pkgs.fish;
    # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsUBONtlC6T4CvTGGkRFcsHYhJiz9KZ+JqJzHOXVOqA syahn-2025-12-13" ];
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
  };

}
