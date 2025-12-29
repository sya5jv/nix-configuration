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

  time.timeZone = "US/Eastern";

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

  systemd.services.gnome-remote-desktop = {
    wantedBy = [ "graphical.target" ];
  };

  powerManagement = {
    enable = true;
    powertop.enable = true;
    resumeCommands = ''
      echo "Resuming device."
    '';
  };

  services = {

    fwupd.enable = true;

    upower.enable = true;

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
      xkb.layout = "us,us";  # Configure keymap in X11
      xkbVariant = ",colemak_dh";  # Configure keymap in X11
      xkbOptions = "grp:alts_toggle";  # Configure keymap in X11
    };

    gnome = {
      gnome-remote-desktop.enable = true;
      gnome-keyring.enable = true;
    };

    displayManager = {
      ly.enable = true;
      autoLogin.enable = false;
    };

    getty.autologinUser = null;

    # Enable sound.
    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

  };

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
    tmux        # Terminal multiplexer
    git         # Version control
    wget        # CLI utility
    tree        # CLI utility
    which       # CLI utility
    sbctl       # Secure boot manager
    tpm2-tss    # TPM2 manager
    tpm2-tools  # TPM2 Utilities
    ly          # TUI Display Manager
    brightnessctl   # Screen brightness utility used by ly
    ffmpeg-full # Media functionality

    # Desktop Envionment Packages

    niri        # Wayland Compositor
    mako        # Desktop Notification Service
    swaybg      # Background Software
    swayidle    # Desktop Idle Status
    swaylock    # Desktop Lock Screen
    xdg-desktop-portal-gtk    # XDG Desktop Portal for Screen Sharing
    xdg-desktop-portal-gnome  # XDG Desktop Portal for Screen Sharing 
    xwayland-satellite        # Wayland support for X11 Programs
    udiskie     # Manage and Auto-mount USB Drives

    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default  # Noctalia shell input from flake.nix
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    config = {
      common.default = [ "gtk" ];
      niri.default = [ "gnome" "gtk" ];
    };
    configPackages = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
  };

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
      allowedTCPPorts = [ 22 3389 ];
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

    polkit.enable = true;

    pam.services.swaylock = {};

  };

  system.stateVersion = "25.11"; # Did you read the comment?

}

