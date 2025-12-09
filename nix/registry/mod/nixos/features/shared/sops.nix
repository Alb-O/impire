/**
  sops-nix NixOS feature.

  Atomic secret provisioning.
*/
{
  __inputs = {
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _: _:
    let
      mod = { inputs, ... }: { imports = [ inputs.sops-nix.nixosModules.sops ]; };
    in
    {
      __exports."nixos.profile.shared".value = mod;
      __module = mod;
    };
}
