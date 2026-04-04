{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Core components for the Dendritic pattern
    flake-parts.url = "github:hercules-ci/flake-parts";   # flake-parts url
    import-tree.url = "github:vic/import-tree";           # recursive module importing

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";   # configuring programs
  };

  # Import modules/ automatically
  outputs = inputs: inputs.flake-parts.lib.mkFlake 
    {inherit inputs;} 
    (inputs.import-tree ./modules);
}
