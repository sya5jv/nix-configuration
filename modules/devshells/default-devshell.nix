# modules/dev/devshell.nix

{ inputs, lib, ... }:
{
  imports = [ inputs.devshell.flakeModule ];

  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      devshells.default = {
        devshell = {
          name = "$(echo $USER)@nix-devshell $(basename '$PWD') ($(git branch --show-current 2>/dev/null))";

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
        ];
      };
    };
}
