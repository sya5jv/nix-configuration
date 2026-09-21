# modules/security/tpm2.nix
{ inputs, lib, ... }: {
  flake.nixosModules.tpm2 =
    { ... }:
    {
      security.tpm2 = {
        enable = true;
        pkcs11.enable = true;
        tctiEnvironment.enable = true;
      };
    };
}
