# modules/hosts/lemontree/configuration.nix
# TODO: Split this out into more modules.
{
  self,
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.lemontreeConfiguration =
    {
      pkgs,
      lib,
      ...
    }:
    {
      # Enabling flakes
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      systemd = {
        sleep.settings.Sleep = {
          AllowSuspend = "yes";
          AllowHibernation = "no";
          AllowHybridSleep = "no";
          AllowSuspendThenHibernate = "no";
        };
      };

      fileSystems = {
        "/".options = [ "compress=zstd" ];
        "/home".options = [ "compress=zstd" ];
        "/nix".options = [
          "compress=zstd"
          "noatime"
        ];
      };

      powerManagement = {
        enable = true;
        powertop.enable = true;
        resumeCommands = ''
          echo "Resuming device."
        '';
      };

      time.timeZone = "America/New_York";

      services = {
        fprintd.enable = false;

        tlp = {
          enable = true;
          settings = {
            CPU_SCALING_GOVERNOR_ON_AC = "performance";
            CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

            CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
            CPU_ENERGY_PERF_POLICY_ON_BAT = "powersave";
            START_CHARGE_THRESH_BAT0 = 75;
            STOP_CHARGE_THRESH_BAT0 = 80;

            # Restore configured thresholds when AC is unplugged
            RESTORE_THRESHOLDS_ON_BAT = 1;

            # NATACPI and TPSMAPI battery care drivers
            NATACPI_ENABLE = 1; # All supported laptops
            TPSMAPI_ENABLE = 1; # ThinkPad specific

            # AMD GPU related settings
            RADEON_DPM_PERF_LEVEL_ON_AC = "auto";
            RADEON_DPM_PERF_LEVEL_ON_BAT = "auto";
            RADEON_DPM_STATE_ON_AC = "performance";
            RADEON_DPM_STATE_ON_BAT = "balanced";
            AMDGPU_ABM_LEVEL_ON_AC = 0;
            AMDGPU_ABM_LEVEL_ON_BAT = 1;
            AMDGPU_ABM_LEVEL_ON_SAV = 3;

            # Platform settings
            # (OS characteristics around power/performance levels, thermal, and fan speed)
            PLATFORM_PROFILE_ON_AC = "performance";
            PLATFORM_PROFILE_ON_BAT = "balanced";
            PLATFORM_PROFILE_ON_SAV = "low-power";

            MEM_SLEEP_ON_AC = "s2idle";
            MEM_SLEEP_ON_BAT = "deep";

            # Radio settings
            RESTORE_DEVICE_STATE_ON_STARTUP = 1;
            DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth wifi wwan";
          };
        };

        upower = {
          enable = true;
          percentageLow = 30;
          percentageCritical = 10;
          criticalPowerAction = "PowerOff";
        };

        # BTRFS automatic data integrity checking
        btrfs.autoScrub = {
          enable = false;
          interval = "monthly";
          fileSystems = [ "/" ];
        };

        # Allow users to SSH onto machine
        openssh.settings.AllowUsers = [ "syahn" ];

        xserver = {
          xkb = {
            layout = "us,us"; # Configure keymap in X11
            variant = ",colemak_dh"; # Configure keymap in X11
            options = "grp:alts_toggle"; # Configure keymap in X11
          };
        };

        getty.autologinUser = null;
      };

      networking.hostName = "lemontree";

      system.stateVersion = "25.11";
    };
}
