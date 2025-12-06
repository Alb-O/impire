# Helium feature - Helium Browser (Chromium fork)
# Custom browser flake from github:Alb-O/helium-browser-flake
{
  __inputs = {
    helium-browser.url = "github:Alb-O/helium-browser-flake";
    helium-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    { inputs, ... }:
    {
      __module =
        { pkgs, ... }:
        {
          home.packages = [
            inputs.helium-browser.packages."${pkgs.system}".helium-prerelease
          ];
        };
    };
}
