/**
  sops-nix feature.

  Atomic secret provisioning for both Home Manager and NixOS.
  HM: User-level secrets management with sops CLI tools
  OS: System-level sops daemon
*/
{
  __inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _: _:
    let
      hm =
        {
          inputs,
          pkgs,
          lib,
          config,
          ...
        }:
        {
          imports = [ inputs.sops-nix.homeManagerModules.sops ];

          home.packages = lib.mkAfter [
            pkgs.sops
            inputs.sops-nix.packages.${pkgs.system}.default
          ];

          sops.age.keyFile = lib.mkDefault "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        };
      os =
        { inputs, ... }:
        {
          imports = [ inputs.sops-nix.nixosModules.sops ];
        };
    in
    {
      __exports."shared.hm".value = hm;
      __exports."shared.os".value = os;
      __module = hm;
    };
}
