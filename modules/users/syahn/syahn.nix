# modules/users/syahn/syahn.nix

{ self, inputs, lib, ... }:
{
  flake.nixosModules.userSyahn =
  { config, pkgs, lib, ... }:
  {
    imports = [ (self.lib.mkUser "syahn") ];

    users.users.syahn = {
      description = "Samuel Ahn, syahn@proton.me";
      uid = 1000;
      group = "users";
      extraGroups = [
        "wheel"
        "rtkit"
        "networkmanager"
        "tss"
        "libvirtd"
      ];
      shell = pkgs.fish;
    };

    i18n = {
      defaultLocale = "en_US.UTF-8";
    };

    programs = {

      git = {
        enable = true;
        config.user = {
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

      yazi.enable = true;

    };
  };
}
