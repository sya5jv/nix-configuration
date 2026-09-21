# modules/dev/devshell.nix
{
  inputs,
  ...
}:
{
  imports = [ inputs.devshell.flakeModule ];

  perSystem =
    {
      pkgs,
      ...
    }:
    {
      devshells.default = {
        devshell = {
          name = "$(echo $USER)@nix-devshell";

          motd = ''
            {202}Nix Devshell{reset}
            $(type -p menu &>/dev/null && menu)
          '';

          startup.default.text = ''
            alias vim=nvim
          '';
        };

        packages = with pkgs; [
          # Nix language tooling (also used by VS Code, see .vscode/settings.json)
          nixd # Language server
          nixfmt # Formatter (official Nix style, RFC 166)
          nixfmt-tree # Provides instance of treefmt to use nixfmt
          statix # Linter: anti-patterns and style suggestions
          deadnix # Linter: unused bindings and arguments

          # Inspecting and comparing configurations
          nvd # Diff two system generations
          nix-tree # Browse closure dependencies interactively
          nix-output-monitor # `nom`: readable build output

          # General repository tooling
          git
        ];

        commands = [
          {
            package = "statix";
            category = "[Code Quality]";
            help = "Linter: Anti-patterns and style suggestions";
          }

          {
            package = "deadnix";
            category = "[Code Quality]";
            help = "Linter: Unused bindings and arguments.";
          }

          {
            name = "test-flake";
            command = "sudo nixos-rebuild test --flake ~/nixos-config#lemontree --show-trace";
            help = "Test a flake rebuild for the lemontree flake with trace.";
            category = "[Shorthands]";
          }

          {
            name = "switch-flake";
            command = "sudo nixos-rebuild switch --flake ~/nixos-config#lemontree --show-trace";
            help = "Test a flake rebuild for the lemontree flake with trace.";
            category = "[Shorthands]";
          }
        ];
      };
    };
}
