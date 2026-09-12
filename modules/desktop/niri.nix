{ self, inputs, lib, ... }: {

  flake.nixosModules.niri =
  { config, pkgs, lib, ... }:
  {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };

    xdg.portal.config.niri = {
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
      "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
    };

    environment.systemPackages = with pkgs; [
      niri
      mako
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
      xwayland-satellite
    ];
  };

  perSystem =
  { pkgs, lib, self', ... }:
  {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {

      inherit pkgs;

      # Niri KDL settings file contents here
      "config.kdl".content = builtins.readFile ./config.kdl;
    };  # packages.myNiri

  }; # perSystem

}

