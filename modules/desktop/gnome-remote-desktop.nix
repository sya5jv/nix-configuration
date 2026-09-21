# modules/desktop/gnome-remote-desktop.nix
# See modules/desktop/xdg-portals.nix for portals required by RDP
{ inputs, lib, ... }:
{
  flake.nixosModules.gnomeRemoteDesktop =
    { ... }:
    {
      services.gnome.gnome-remote-desktop.enable = true;

      systemd.services.gnome-remote-desktop = {
        wantedBy = [ "graphical.target" ];
      };
    };
}
