{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      packages = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, ... }: {

    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {

      inherit pkgs;

      # Niri KDL settings file contents here
      settings = {

        input.keyboard = {
          xkb.layout= "us";
        };

        layout.gaps = 5;

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+Q".close-window = null;
        };

      };  # settings

    };  # packages.myNiri

  };

}

