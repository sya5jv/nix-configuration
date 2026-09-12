# modules/system/packages.nix

{ self, inputs, lib, ... }:
{
  flake.nixosModules.systemPackages =
  { config, pkgs, lib, ... }:
  {
    imports = [ inputs.noctalia-greeter.nixosModules.default ];

    environment.systemPackages = with pkgs; [
      eza
      zoxide
      vesktop
      alacritty
      ghostty
      greetd
      claude-code
      net-tools
      iproute2
      yazi
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
      ffmpeg-full # Media functionality
      parted
      hdparm
      libarchive
      inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];

    nixpkgs.config.allowUnfreePredicate = pkgs: builtins.elem (lib.getName pkgs) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
      "spotify"
      "claude-code"
    ];

    programs = {
      # ssh-agent
      ssh = {
        startAgent = false;
        extraConfig = ''
          Host github.com
            AddKeysToAgent yes
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

      steam = {
        enable = true;
        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
      };

      gamemode.enable = true;

      noctalia-greeter = {
        enable = true;
        settings = {
          cursor = {
            theme = "Bibata-Modern-Ice";
            size = 24;
            path = "${pkgs.bibata-cursors}/share/icons";
          };
        };
      };

    };
  };
}
