{ config, ... }: {

  imports = [ /.hardware-configuration.nix ];

  networking = {

    hostName = "lemontree";

    firewall = {

      enable = true;
      allowedTCPPorts = [ 22 ];
      # allowedUDPPorts = [ ... ];

    };

  };

}
