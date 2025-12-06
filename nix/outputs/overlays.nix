# Flake overlays output
# Collected from __overlays in registry modules
{
  __inputs = {
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    { inputs, ... }:
    {
      nur = inputs.nur.overlays.default;
    };
}
