# modules/system/networking.nix
{
  inputs,
  lib,
  ...
}:
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

      # Set 'fail2ban' banactions to use 'nftables'
      # See the rest of the config in 'modules/services/fail2ban.nix'
      services.fail2ban = {
        banaction = "nftables";
        banaction-allports = "nftables[type=allports]";
      };
    };
}
