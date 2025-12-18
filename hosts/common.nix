{ config, inputs, ... }: {

  imports = [];

  nix = {

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };

    settings = {
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "@wheel" ];
    };

  };

  nixpkgs = {

    config.allowUnfree = true;
    flake.setNixPath = true;

    overlays = [ inputs.self.overlays.default ];

  };

  boot.tmp = {
    cleanOnBoot = true;
    useTmpfs = true;
  };

  # Make Nix use /var/tmp for building, so that large 
  # files don't have to live in tmpfs
  systemd.services.nix-daemon.environment.TMPDIR = "/var/tmp";

  services.dbus.implementation = "broker";

  # Disabled until further development with swapfile
  zramSwap = {
    enable = false;
    algorithm = "zstd";
  };

  # Disabled until further research
  system = {
    autoUpgrade = false;
    flags = [ "--refresh" ];
  };

  system.stateVersion = "25.11";

}
