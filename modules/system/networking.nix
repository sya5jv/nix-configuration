# modules/system/networking.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.networking =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      networking = {
        # NetworkManager
        networkmanager.enable = true;

        # Firewall
        firewall.enable = true;
        nftables.enable = true; # Opt for nftables-based firewall instead of iptables
      };
    };
}
