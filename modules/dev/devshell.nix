# modules/dev/devshell.nix

{ inputs, lib, ... }:
{
  perSystem =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      devShells.default = pkgs.mkShellNoCC {
        name = "nixos-config";

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
          ripgrep
        ];
      };

      # `nix fmt` runs treefmt with nixfmt over the whole repository
      formatter = pkgs.nixfmt-tree;
    };
}
