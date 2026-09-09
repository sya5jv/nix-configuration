# modules/services/openssh.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.openssh =
    { config, lib, pkgs, ... }:
    {
      services.openssh = {
        enable = true;
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };
    };
}
