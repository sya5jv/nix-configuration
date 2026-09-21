# modules/services/openssh.nix
{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.openssh =
    { lib, ... }:
    {
      services.openssh = {
        enable = true;
        ports = lib.mkDefault [ 22 ];
        settings = {
          PasswordAuthentication = true;
          PermitRootLogin = "no";
        };
      };
    };
}
