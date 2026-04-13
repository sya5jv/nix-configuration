{ inputs, ... }:
{
  imports = [
    inputs.hjem.nixosModules.hjem
  ];

  hjem.clobberByDefault = false;  # While true, overwrites existing files on rebuild

}
