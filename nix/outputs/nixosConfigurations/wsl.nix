# WSL NixOS configuration
{
  __inputs.nixos-wsl = {
    url = "github:nix-community/NixOS-WSL";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    {
      self,
      lib,
      inputs,
      imp,
      registry,
      exports,
      ...
    }:
    lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {
        inherit
          self
          inputs
          imp
          registry
          exports
          ;
      };
      modules = imp.imports [
        registry.hosts.wsl
      ];
    };
}
