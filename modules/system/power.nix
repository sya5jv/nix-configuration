# modules/system/power.nix

{ ... }:
{
  flake.nixosModules.power =
    { ... }:
    {
      systemd.sleep.settings.Sleep = {
        AllowSuspend = "yes";
        AllowHibernation = "no";
        AllowHybridSleep = "no";
        AllowSuspendThenHibernate = "no";
      };
    };
}
