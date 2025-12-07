# sops-nix home-manager feature - user-level secrets
# Note: Requires sops-nix NixOS module for system-level sops daemon
{
  __inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    { inputs, ... }:
    {
      __module =
        {
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

          # Default age key location
          sops.age.keyFile = lib.mkDefault "${config.home.homeDirectory}/.config/sops/age/keys.txt";
        };
    };
}
