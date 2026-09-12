# modules/desktop/fonts.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.fonts =
  { config, pkgs, lib, ... }:
  {
    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
}
