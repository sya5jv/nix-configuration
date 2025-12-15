# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
       ./hardware-configuration.nix
       ./main-user.nix
      inputs.home-manager.nixosModules.default
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  main-user.enable = true;
  main-user.username = "syahn";

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "syahn" = import ./home.nix;
    };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;
  # boot.resumeDevice = "/dev/dm-1";  # WIP: Need to look at TPM

  boot.initrd.kernelModules = [ "dm-snapshot" "cryptd" ];
  boot.initrd.systemd = {
    enable = true;
  };
  boot.initrd.luks.devices = {
    luksroot = {
      device = "/dev/nvme0n1p2";
      preLVM = true;
    };
  };

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

  services.tlp = {
    enable = true;
    settings = {
      # Processor settings
      CPU_DRIVER_OPMODE_ON_AC = "active";
      CPU_DRIVER_OPMODE_ON_BAT = "active";
      CPU_DRIVER_OPMODE_ON_SAV = "guided";

      CPU_SCALING_GOVERNOR_ON_AC = "performance";
      CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
      CPU_SCALING_GOVERNOR_ON_SAV = "powersave";

      CPU_ENERGY_PERF_POLICY_ON_AC = "balanced_performance";
      CPU_ENERGY_PERF_POLICY_ON_BAT = "balanced_power";
      CPU_ENERGY_PERF_POLICY_ON_SAV = "power";

      # CPU_MIX_PERF_ON_AC = 0;   # Unsure if AMD can use these settings
      # CPU_MAX_PERF_ON_AC = 100;
      # CPU_MIX_PERF_ON_BAT = 0;
      # CPU_MAX_PERF_ON_BAT = 80;
      # CPU_MIX_PERF_ON_SAV = 0;
      # CPU_MAX_PERF_ON_SAV = 60;

      # Charging thresholds
      START_CHARGE_THRESH_BAT0 = 40;
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

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitchDocked = "ignore";
  };

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
      # AllowUsers = [ "syahn" "hasoony" ];
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
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.syahn = {
  #   isNormalUser = true;
  #   home = "/home/syahn";
  #   uid = 1000;
  #   group = "users";
  #   extraGroups = [
  #     "wheel"
  #     "networkmanager"
  #     "tss"
  #   ];
  #   # openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKsUBONtlC6T4CvTGGkRFcsHYhJiz9KZ+JqJzHOXVOqA syahn-2025-12-13" ];
  # };

  # users.users.hasoony = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ];
  #   packages = with pkgs; [
  #     tree
  #   ];
  # };

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    fish      # Shell
    vim       # Text editor
    neovim    # Text editor
    fastfetch # System monitoring
    tmux      # Terminal multiplexer
    git       # Version control
    zoxide    # CLI utility
    fzf       # CLI utility
    wget      # CLI utility
    bat       # CLI utility
    tree      # CLI utility
    dysk      # System monitoring
    btop      # System monitoring
    which     # CLI utility
    sbctl     # Secure boot manager
    tpm2-tss  # TPM2 manager
  ];

  # environment.variables = rec {
  # };

  programs = {
    ssh.startAgent = true;

    fish.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };
  };

  networking = {
    # Set network hostname
    hostName = "lemontree";

    # Configure network connections using NetworkManager
    networkmanager = {
      enable = true;
    };

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

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
      # allowedUDPPorts = [ ... ];
    };
  };

  security = {
    tpm2 = {
      enable = true;

      abrmd.enable = true;
      pkcs11.enable = true;

      tctiEnvironment.enable = true;
      tctiEnvironment.interface = "tabrmd";
    };
  };

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
  system.stateVersion = "25.11"; # Did you read the comment?

}
