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
    # Now scans: mod/, hosts/, roles/, users/
    registry.src = ./..;

    # Auto-generate flake.nix from __inputs declarations
    flakeFile = {
      enable = true;
      coreInputs = import ./inputs.nix;
      description = "Albert's NixOS configuration using imp";
      outputsFile = "./flake";
    };

    # Export sinks configuration
    exports = {
      # Scan mod/ for exports
      sources = [ ../mod ];
      # Use mkMerge for role-based module collections
      sinkDefaults = {
        "shared.*" = "mkMerge";
        "desktop.*" = "mkMerge";
      };
    };

    # Auto-generate nixosConfigurations from __host declarations
    hosts = {
      enable = true;
      sources = [ ../hosts ];
      defaults = {
        system = "x86_64-linux";
        stateVersion = "24.11";
      };
    };
  };
}
