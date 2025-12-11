/**
  Neovim feature.

  Nightly build from neovim-nightly-overlay.
*/
{
  __inputs = {
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _: _:
    let
      mod =
        { inputs, pkgs, ... }:
        {
          programs.neovim = {
            enable = true;
            package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
          };
        };
    in
    {
      __exports.shared.hm.value = mod;
      __module = mod;
    };
}
