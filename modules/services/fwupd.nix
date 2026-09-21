# modules/services/fwupd.nix
# TODO: Figure out how to organize this. ~10 line wrappers for oneliners?
{ inputs, lib, ... }:
{
  flake.nixosModules.fwupd =
    { ... }:
    {
      services.fwupd.enable = true;
    };
}
