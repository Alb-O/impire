# Core inputs for imp flake operation
{
  nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  flake-parts.url = "github:hercules-ci/flake-parts";
  imp.url = "github:imp-nix/imp.lib";
  home-manager = {
    url = "github:nix-community/home-manager";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  # Registry migration tool (follows imp's bundled version)
  imp-refactor.follows = "imp/imp-refactor";
}
