/**
  Helium Browser (Chromium fork) from github:Alb-O/helium-browser-flake.
*/
{
  __inputs = {
    helium-browser.url = "github:Alb-O/helium-browser-flake";
    helium-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _: _:
    let
      mod =
        { inputs, pkgs, ... }:
        {
          home.packages = [
            inputs.helium-browser.packages."${pkgs.system}".helium-prerelease
          ];
        };
    in
    {
      __exports.desktop.hm.value = mod;
      __module = mod;
    };
}
