/**
  sops-nix home-manager feature.

  User-level secrets. Requires sops-nix NixOS module for system-level sops daemon.
*/
{
  __inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _: _:
    let
      mod =
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
    in
    {
      __exports."hm.profile.shared".value = mod;
      __module = mod;
    };
}
