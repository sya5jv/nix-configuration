{ self, inputs, lib, ... }: {

  flake.nixosModules.lemontreeConfiguration =
  { pkgs, lib, ... }:
  {

    # Enabling flakes
    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    systemd = {

      sleep.settings.Sleep.enable = true;

      services.gnome-remote-desktop = {
        wantedBy = [ "graphical.target" ];
      };

    };

    fileSystems = {
      "/".options = [ "compress=zstd" ];
      "/home".options = [ "compress=zstd" ];
      "/nix".options = [ "compress=zstd" "noatime" ];
    };

    powerManagement = {
      enable = true;
      powertop.enable = true;
      resumeCommands = ''
        echo "Resuming device."
      '';
    };

    time.timeZone = "US/Eastern";

    services = {

      fprintd.enable = false;

      fwupd.enable = true;

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
          NATACPI_ENABLE = 1;   # All supported laptops
          TPSMAPI_ENABLE = 1;   # ThinkPad specific

          # AMD GPU related settings
          RADEON_DPM_PERF_LEVEL_ON_AC="auto";
          RADEON_DPM_PERF_LEVEL_ON_BAT="auto";
          RADEON_DPM_STATE_ON_AC="performance";
          RADEON_DPM_STATE_ON_BAT="balanced";
          ADMGPU_ABM_LEVEL_ON_AC=0;
          ADMGPU_ABM_LEVEL_ON_BAT=1;
          ADMGPU_ABM_LEVEL_ON_SAV=3;

          # Platform settings
          # (OS characteristics around power/performance levels, thermal, and fan speed)
          PLATFORM_PROFILE_ON_AC="performance";
          PLATFORM_PROFILE_ON_BAT="balanced";
          PLATFORM_PROFILE_ON_SAV="low-power";

          MEM_SLEEP_ON_AC="s2idle";
          MEM_SLEEP_ON_BAT="deep";

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

      # Laptop lid power settings
      logind.settings.Login = {
        HandleLidSwitch = "suspend";
        HandleLidSwitchExternalPower = "suspend";
        HandleLidSwitchDocked = "ignore";
      };

      # BTRFS automatic data integrity checking
      btrfs.autoScrub = {
        enable = false;
        interval = "monthly";
        fileSystems = [ "/" ];
      };

      # Enable the OpenSSH daemon.
      openssh = {
        enable = true;
        ports = [ 22 ];
        settings = {
          PasswordAuthentication = true;  # should be false
          KbdInteractiveAuthentication = false;  # should be false
          PermitRootLogin = "no";
          AllowUsers = [ "syahn" ];
        };
      };

      fail2ban = {
        enable = true;
        # Ban IP after 5 failures
        maxretry = 5;
        ignoreIP = [
          "127.0.0.0/8"   # Default made explicit
          "::1"           # Default made explicit
          "192.168.0.0/16"
        ];
        bantime = "24h";
        bantime-increment = {
          enable = true;        # Enable increment of bantime after each violation
          # formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
          multipliers = "1 2 4 8 16 32 64";
          maxtime = "168h";     # One week
          overalljails = true;  # Calculate the bantime based on all the violations
        };
        jails = {
          sshd.settings = {
            # Block an IP address if it accesses a non-extistent
            # home directory more than 5 times in 10 minutes
            # since that indicates that it's scanning
            enabled = "false";
            port = "ssh";
            filter = "sshd";
            logpath = "/var/log/auth.log";
            maxretry = 5;
            findtime = 300;
            bantime = 3600;
            ignoreip = "127.0.0.1";
          };
        };
      };

      xserver = {
        xkb = {
          layout = "us,us";  # Configure keymap in X11
          variant = ",colemak_dh";  # Configure keymap in X11
          options = "grp:alts_toggle";  # Configure keymap in X11
        };
      };

      gnome = {
        gnome-remote-desktop.enable = true;
        gnome-keyring.enable = true;
      };

      getty.autologinUser = null;

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;

    };

    networking.hostName = "lemontree";

    security = {
      tpm2 = {
        enable = true;

        abrmd.enable = true;
        pkcs11.enable = true;

        tctiEnvironment.enable = true;
        tctiEnvironment.interface = "tabrmd";
      };

      polkit.enable = true;

      pam.services = {
        # greetd = {
        #   fprintAuth = true;
        # };
        swaylock = {};
      };

    };

    system.stateVersion = "25.11";
  };
}
