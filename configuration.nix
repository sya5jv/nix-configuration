{ config, lib, pkgs, inputs, ... }:
{
  imports =
    [
       ./hardware-configuration.nix   # Hardware configuration for lemontree (Lenovo ThinkPad P14s Gen 6)
    ];

  # Enabling flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # systemd-boot EFI boot loader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Kernel modules on startup
  boot.initrd.kernelModules = [ 
    "dm-snapshot" # dm-snapshot for btrfs CoW snapshots
    "cryptd"      # cryptd for LUKS encryption of disk
  ];

  # Enabling systemd at stage 1 for suspensions and hibernation on encryted disks
  boot.initrd.systemd = {
    enable = true;
  };

  # Specifying which device is LUKS encrypted
  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

  # Device hibernation
  # boot.resumeDevice = "/dev/dm-1";  # WIP: Need to look at TPM in order to look at automatic device unlocking

  fileSystems = {
    "/".options = [ "compress=zstd" ];
    "/home".options = [ "compress=zstd" ];
    "/nix".options = [ "compress=zstd" "noatime" ];
  };

  systemd.sleep.extraConfig = ''
    AllowSuspend=yes
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernation=no
  '';

  powerManagement = {
    enable = true;
    powertop.enable = true;
    resumeCommands = ''
      echo "Resuming device."
    '';
  };

  # services.tuned.enable = true;

  services.upower.enable = true;

  # services.tlp = {
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
  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

  # BTRFS automatic data integrity checking
  services.btrfs.autoScrub = {
    enable = false;
    interval = "monthly";
    fileSystems = [ "/" ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;  # should be false
      KbdInteractiveAuthentication = false;  # should be false
      PermitRootLogin = "no";
      AllowUsers = [ "syahn" ];
    };
  };

  services.fail2ban = {
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
  # services.xserver.enable = true;

  # Configure keymap in X11
  services.xserver.xkb.layout = "us";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.syahn = {
    isNormalUser = true;
    home = "/home/syahn";
    uid = 1000;
    group = "users";
    extraGroups = [
      "wheel"
      "networkmanager"
      "tss"
    ];
    shell = pkgs.fish;
    # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsUBONtlC6T4CvTGGkRFcsHYhJiz9KZ+JqJzHOXVOqA syahn-2025-12-13" ];
  };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    fish        # Shell
    vim         # Text editor
    neovim      # Text editor
    tmux        # Terminal multiplexer
    ghostty     # Terminal emulator
    git         # Version control
    zoxide      # CLI utility
    fzf         # CLI utility
    wget        # CLI utility
    bat         # CLI utility
    tree        # CLI utility
    dysk        # System monitoring
    btop        # System monitoring
    which       # CLI utility
    sbctl       # Secure boot manager
    tpm2-tss    # TPM2 manager
    tpm2-tools  # TPM2 Utilities
    niri        # Wayland Compositor
    quickshell  # Wayland shell program
    ly          # TUI Display Manager
    xwayland-satellite  # Wayland support for X11 Programs

    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default  # Noctalia shell input from flake.nix
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs = {

    # ssh-agent
    ssh = {
      startAgent = false;
      extraConfig = ''
        Host github.com
          IdentityFile ~/.ssh/id_ed25519_20251214
      '';
    };

    # fish shell
    fish.enable = true;

    # Neovim editor
    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # Wayland Compositor
    niri.enable = true;

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

  hardware.bluetooth.enable = true;

  security = {
    tpm2 = {
      enable = true;

      abrmd.enable = true;
      pkcs11.enable = true;

      tctiEnvironment.enable = true;
      tctiEnvironment.interface = "tabrmd";
    };
  };

  system.stateVersion = "25.11"; # Did you read the comment?

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
