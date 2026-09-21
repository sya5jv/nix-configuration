# modules/services/gnomeKeyring.nix
# Keyring for passwords, keys, and certs through org.freedesktop.secrets API
{ inputs, lib, ... }:
{
  flake.nixosModules.gnomeKeyring =
    { ... }:
    {
      services.gnome.gnome-keyring.enable = true;
    };
}
