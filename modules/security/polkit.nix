# modules/security/polkit.nix
{ inputs, lib, ... }:
{
  flake.nixosModules.polkit =
    { ... }:
    {
      security.polkit.enable = true;
    };
}
