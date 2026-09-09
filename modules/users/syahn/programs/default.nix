{ config, inputs, pkgs, lib, ... }:
{

  imports = [
    inputs.nix-index-database.nixosModules.nix-index
  ];

  users.users.syahn.shell = pkgs.fish;

  hjem.users.syahn = {

    packages = with pkgs; [
      # Essentials
      fish
      tmux
      neovim
      git
      ghostty

      # CLI Utilities
      fastfetch
      ripgrep
      bat
      fzf
      zoxide
      tree
      which
      eza
      lazygit
      yazi

      # System Monitoring
      btop
      iotop
      iftop

      # System Tools
      sysstat
      lm_sensors
      ethtool
      pciutils
      usbutils
      dysk

      # Syscall Monitoring
      strace
      ltrace
      lsof

      # Archiving and Compression
      zip
      xz
      unzip
      p7zip
      zstd

      # Nix Related
      nix-search-tv
      nix-tree
      # (pkgs.writeShellApplication {
      #   name = "ns";
      #   runtimeInputs = with pkgs; [
      #     fzf
      #     nix-search-tv
      #   ];
      #   text = builtins.readFile "{pkgs.nix-search-tv.src}/nixpkgs.sh";
      # })

      # Programs
      vesktop
      fuzzel

    ];

    programs = {

      nix-index-database.comma.enable = true;

      git = {
        enable = true;
        settings.user = {
          name = "Samuel Ahn";
          email = "sya5jv@virginia.edu";
        };
      };

      fish = {
        enable = true;

        shellInit = ''
          if status is-interactive
              # Commands to run in interactive sessions can go here
          end

          set -g fish_key_bindings fish_vi_key_bindings
          zoxide init --cmd cd fish | source
          abbr -a --position anywhere vim nvim
          abbr -a --position anywhere ... ../..
          abbr -a --position anywhere .... ../../..
          abbr -a --position anywhere ..... ../../../..
          abbr -a !! --position anywhere --function last_history_item

          set fish_cursor_default block
          set fish_cursor_insert block blink
          set fish_cursor_replace_one underscore
          set fish_cursor_replace underscore blink
          set fish_cursor_external line
          set fish_cursor_visual block
        '';

        shellAbbrs = {
          add = "git add";
          branch = "git branch";
          checkout = "git checkout";
          cherrypick = "git cherry-pick";
          clone = "git clone";
          commit = "git commit";
          fetch = "git fetch --prune";
          merge = "git merge";
          pull = "git pull";
          push = "git push";
          rebase = "git rebase";
          reset = "git reset @ --hard";
          stash = "git stash";
          status = "git status";
          switch = "git switch";
          tag = "git tag";

          sl = "eza";
          ls = "eza";
          ll = "eza --long -g";
          la = "eza --long -ag";
        };
      };

      alacritty.enable = true;
      yazi = {
        enable = true;
        shellWrapperName = "y";
      };

    };
  };

}

