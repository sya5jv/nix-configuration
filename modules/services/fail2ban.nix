# modules/services/fail2ban.nix
{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.fail2ban =
    { ... }:
    {
      services.fail2ban = {
        enable = true;
        maxretry = 5;
        ignoreIP = [
          # Explicit Defaults
          "127.0.0.1/8"
          "::1"
          # Home LAN
          "192.168.0.0/16"
        ];
        bantime = "24h";
        bantime-increment = {
          enable = true;
          # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
          multipliers = "1 2 4 8 16 32 64";
          maxtime = "168h"; # One week
          overalljails = true; # Calculate bantime based on all violations
        };
        jails = {
          sshd.settings = {
            # Blocks an IP address if it accesses a non-existent home directory more than 5 times
            # in 10 minutes since that indicates scanning
            enabled = "true";
            port = "ssh";
            filter = "sshd";
            logpath = "/var/log/auth.log";
            maxretry = 5;
            findtime = 300; # Five minutes
            bantime = 3600; # One hour
            ignoreip = "127.0.0.1";
          };
        };
      };
    };
}
