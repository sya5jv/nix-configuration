# Lemontree NixOS Configuration Files

## Description

This repository will serve as a way to store and version control the Lemontree host's configuration files for NixOS

## Details

Currently, the NixOS configuration is set up in a very immature state.

### Configuration Files

1. NixOS is set up with flakes and experimental features on, but only utilized a main `flake.nix` file.
    - TODO: Research how to create modular flakes
2. All system level configurations are stored on `configuration.nix` and must be modularized.
    - TODO: Separate the system level configurations into individual configuration modules
3. Home-manager is installed in the flake as a module, but no modules currently exist outside of `home.nix`.
    - TODO: Figure out how home-manager modules work to add more programs and configurations
4. All user level configurations are made in `home.nix`, and only one user configuration exists for `syahn`.
    - TODO: Separate currently installed programs into their own modules.
    - TODO: Dotfile configurations for utilities and UIs.
    - TODO: Figure out how to symlink dotfiles

### Desktop Environment

The desktop environment's tech stack is currently as follows:

- Ly display manager
    - TODO: Add support for brightness adjustment.
- Wayland
- Niri wayland compositor
- Quickshell + Noctalia-Shell for wayland desktop shell

### System Setup

The system setup is as follows:

- LUKS encrypted root and swap partitions
- BTRFS filesystem set up with subvolumes on root, home, and nix.
    - TODO: Figure out subvolume for snapshots
    - TODO: Figure out how to automate backup and manage backups
- TODO: TPM2 chip should be used for encryption on this device
- TODO: Secure boot should be enabled using Limine or Lanzaboote (this may replace systemd-boot as a bootloader)
- TODO: Automatic decryption of the LUKS encrypted drive for boot stage 2
- TODO: Automate NixOS garbage collection
- Utilize all laptop hardware
    - TODO: Figure out fingerprint scanner usage
    - TODO: Figure out always on USB (may be a boot interaction)
    - TODO: Figure out the copilot button

## Workflow

### NixOS

1. Changes are made to configuration files and tested by running `nixos-rebuild test --flake ~/nixos-config#lemontree`
2. Once everything works, publish using either `switch` or `boot` flags
3. Make sure to copy over new configuration files to `/etc/nixos/` until system boots off of `~/nixos-config`
4. Prune unneeded test generations

### Git

- Small feature additions should have their own branches
- Larger projects should have one trunk branch with feature branches
- Working changes should be merged to main
- Commits should be atomic, meaningful, and easy to spot and revert.
