# modules/system/networking.nix

{ inputs, lib, ... }:
{
  flake.nixosModules.networking =
    { config, lib, pkgs, ... }:
    {
      # NetworkManager
      networking.networkmanager.enable = true;

      # Firewall
      networking.firewall.enable = true;
      networking.nftables.enable = true; # Opt for nftables-based firewall instead of iptables
    };
}
