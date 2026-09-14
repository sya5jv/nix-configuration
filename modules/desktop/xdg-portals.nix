# modules/desktop/xdg-portals.nix

# Explicitly required for niri RDP

{ inputs, lib, ... }:
{
  flake.nixosModules.xdgPortals =
  { config, pkgs, lib, ... }:
  {
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      config = {
        common.default = [ "gnome" "gtk" ];
      };
      configPackages = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
    };
  };
}
