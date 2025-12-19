{ config, lib, inputs, pkgs, ... }: {

  imports = with inputs.nixos-hardware.nixosModules; [
    ../common.nix
    ./hardware-configuration.nix
    lenovo-thinkpad-p14s-amd-gen5
  ];

  boot = {

    kernelPackages = pkgs.linuxPackages_latest;

    initrd = {

      kernelModules = [
        "dm-snapshot"
        "cryptd"
      ];

      systemd.enable = true;

      luks.devices = {
        luksroot = {
          device = "/dev/nvme0n1p2";
          preLVM = true;
        };
      };

      # verbose = false;

    };

    loader = {
      limine = {
        enable = true;
        maxGenerations = 10;
        enrollConfig = true;
        secureBoot.enable= true;
      };
      # systemd-boot.enable = true;   # This bootloader conflicts with Limine
      efi.canTouchEfiVariables = true;
    };

    # consoleLogLevel = 0;    # Disabled until Plymouth configuration

    # plymouth.enable = true;
    # kernelParams = [
    #   "quiet"
    #   "plymouth.use-simpledrm"
    # ];

  };

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  networking = {
    hostName = "lemontree";

    networkmanager = {
      enable = true;
    };

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      # allowedUDPPorts = [ ... ];
    };
  };

  programs = {

    # ssh-agent
    ssh = {
      startAgent = false;   # Needs to be set to false to play nicely with Niri
      extraConfig = ''
        Host github.com
          IdentityFile ~/.ssh/id_ed25519_20251214
      '';
    };

    # fish shell
    fish.enable = true;

    # bash
    bash.enable = true;

    # Neovim editor
    neovim = {
      enable = true;
      defaultEditor = true;
    };

  };

  hardware.bluetooth.enable = true;

  systemd = {

    # Hibernation related settings disabled until
    # secureboot and auto-decryption is handled
    sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=no
      AllowHybridSleep=hibernation=no
      AllowSuspendThenHibernation=no
    '';

    # Automatically update timezone based on physical location
    services.automatic-timezoned.enable = true;

  };

  security = {
    tpm2 = {
      enable = true;

      abrmd.enable = true;
      pkcs11.enable = true;

      tctiEnvironment.enable = true;
      tctiEnvironment.interface = "tabrmd";
    };

    rtkit.enable = true;  # Real-time Audio software occasionally relies on this
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    resumeCommands = ''
      echo "Resuming device."
    '';
  };

  services = {

    # Auto-mounting disks outside of traditional DEs like GNOME or KDE
    udisks2.enable = true;

    # Disabled since it doesn't play nicely with Niri
    tlp.enable = false;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa.enable = true;   # For programs that talk directly to ALSA
      jack.enable = true;   # For specific audio programs
    };

    # tuned.enable = true;

    upower.enable = true;

    # tlp = {
    #   enable = true;
    #   settings = {
    #     # CPU scaling driver operating mode (adjusts processor freqs)
    #     CPU_DRIVER_OPMODE_ON_AC = "active";
    #     CPU_DRIVER_OPMODE_ON_BAT = "active";
    #     CPU_DRIVER_OPMODE_ON_SAV = "guided";

    #     # CPU usage governor (rate limiter) settings
    #     CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #     CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    #     CPU_SCALING_GOVERNOR_ON_SAV = "powersave";

    #     # CPU energy performance policies
    #     CPU_ENERGY_PERF_POLICY_ON_AC = "balanced_performance";
    #     CPU_ENERGY_PERF_POLICY_ON_BAT = "balanced_power";
    #     CPU_ENERGY_PERF_POLICY_ON_SAV = "power";

    #     # Charging thresholds
    #     START_CHARGE_THRESH_BAT0 = 75;
    #     STOP_CHARGE_THRESH_BAT0 = 80;

    #     # Restore configured thresholds when AC is unplugged
    #     RESTORE_THRESHOLDS_ON_BAT = 1;

    #     # NATACPI and TPSMAPI battery care drivers
    #     NATACPI_ENABLE = 1;   # All supported laptops
    #     TPSMAPI_ENABLE = 1;   # ThinkPad specific

    #     # AMD GPU related settings
    #     RADEON_DPM_PERF_LEVEL_ON_AC="auto";
    #     RADEON_DPM_PERF_LEVEL_ON_BAT="auto";
    #     RADEON_DPM_STATE_ON_AC="performance";
    #     RADEON_DPM_STATE_ON_BAT="balanced";
    #     ADMGPU_ABM_LEVEL_ON_AC=0;
    #     ADMGPU_ABM_LEVEL_ON_BAT=1;
    #     ADMGPU_ABM_LEVEL_ON_SAV=3;

    #     # Platform settings 
    #     # (OS characteristics around power/performance levels, thermal, and fan speed)
    #     PLATFORM_PROFILE_ON_AC="performance";
    #     PLATFORM_PROFILE_ON_BAT="balanced";
    #     PLATFORM_PROFILE_ON_SAV="low-power";

    #     # Default sleep profiles
    #     MEM_SLEEP_ON_AC="deep";
    #     MEM_SLEEP_ON_BAT="deep";

    #     # Radio devices settings
    #     RESTORE_DEVICE_STATE_ON_STARTUP = 1;
    #     DEVICES_TO_ENABLE_ON_STARTUP = "bluetooth wifi wwan";
    #   };
    # };

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

    # Enable the X11 windowing system.
    # xserver.enable = true;

    # Configure keymap in X11
    xserver.xkb.layout = "us";

    # Enable CUPS to print documents.
    # printing.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;



  };

}

# Archived comments from nixos-generate-config

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# Some programs need SUID wrappers, can be configured further or are
# started in user sessions.
# mtr.enable = true;
# gnupg.agent = {
#   enable = true;
#   enableSSHSupport = true;
# };

# Configure network proxy if necessary
# From default 'configuration.nix'
# proxy = {
#   default = "http://user:password@proxy:port/";
#   noProxy = "127.0.0.1,localhost,internal.domain";
# };

# Configure nftables
# https://nixos.wiki/wiki/Networking
# nftables = {
#   enable = true;
#   ruleset = ''
#       table ip nat {
#         chain PREROUTING {
#           type nat hook prerouting priority dstnat; policy accept;
#           iifname "ens3" tcp dport 80 dnat to 10.100.0.3:80
#         }
#       }
#     '';
# };

# Copy the NixOS configuration file and link it from the resulting system
# (/run/current-system/configuration.nix). This is useful in case you
# accidentally delete configuration.nix.
# system.copySystemConfiguration = true;

# This option defines the first version of NixOS you have installed on this particular machine,
# and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
#
# Most users should NEVER change this value after the initial install, for any reason,
# even if you've upgraded your system to a new NixOS release.
#
# This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
# so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
# to actually do that.
#
# This value being lower than the current NixOS release does NOT mean your system is
# out of date, out of support, or vulnerable.
#
# Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
# and migrated your data accordingly.
#
# For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
