# modules/security/pam.nix
{ inputs, lib, ... }:
{
  flake.nixosModules.pam =
    { ... }:
    {
      security.pam.services = {
        # Disabled for now. Firguring out greetd...
        greetd.enable = false;
      };
    };
}
