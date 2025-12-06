# sops-nix NixOS feature - atomic secret provisioning
{
  __inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    { inputs, ... }:
    {
      __module = {
        imports = [ inputs.sops-nix.nixosModules.sops ];
      };
    };
}
