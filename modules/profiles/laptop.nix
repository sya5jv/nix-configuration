# modules/profiles/laptop.nix
{
  inputs,
  lib,
  ...
}:
{
  flake.nixosModules.laptopConfiguration =
    { lib, ... }:
    {
      powerManagement = {
        enable = true;
        powertop.enable = true;
        resumeCommands = ''
          echo "Resuming device."
        '';
      };

      services = {
        # Enable Touchpad Support
        libinput.enable = true;

        # logind Laptop Lid Settings
        logind.settings.Login = {
          HandleLidSwitch = lib.mkDefault "suspend";
          HandleLidSwitchExternalPower = lib.mkDefault "suspend";
          HandleLidSwitchDocked = lib.mkDefault "ignore";
        };

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
      };

    };
}
