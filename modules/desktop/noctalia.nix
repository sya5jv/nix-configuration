# modules/desktop/nocatalia.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.noctalia =
  { config, pkgs, lib, ... }:
  {
    environment.systemPackages = with pkgs; [
      inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default # Noctalia input from flake.nix
    ];
  };
}
