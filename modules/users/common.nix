{ inputs, ... }:
{

  imports = [
    inputs.hjem.nixosModules.hjem
  ];

  hjem.clobberByDefault = false;  # When true, overwrites existing files on rebuild

}
