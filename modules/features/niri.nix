{ self, inputs, ... }: {

  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {

    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {

      inherit pkgs;

      # Niri KDL settings file contents here
      "config.kdl".content = builtins.readFile ./config.kdl;
    };  # packages.myNiri

  }; # perSystem

}

