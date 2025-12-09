# Flake outputs entry point
# This file is referenced by the auto-generated flake.nix
inputs:
let
  inherit (inputs)
    nixpkgs
    flake-parts
    imp
    ;
in
flake-parts.lib.mkFlake { inherit inputs; } {
  imports = [
    imp.flakeModules.default
  ];

  # imp configuration
  imp = {
    src = ../outputs;

    # Extra args available in all output files
    args.nixpkgs = nixpkgs;

    # Registry: reference modules by name instead of path
    registry.src = ../registry;

    # Auto-generate flake.nix from __inputs declarations
    flakeFile = {
      enable = true;
      coreInputs = import ./inputs.nix;
      description = "Albert's NixOS configuration using imp";
      outputsFile = "./nix/flake";
    };

    # Export sinks configuration
    exports = {
      # Only scan registry for exports (outputs contain config, not modules)
      sources = [ ../registry ];
      # Use mkMerge for role-based module collections
      sinkDefaults = {
        "shared.*" = "mkMerge";
        "desktop.*" = "mkMerge";
      };
    };
  };
}
