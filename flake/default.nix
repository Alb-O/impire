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
    # Scans parent directory containing mod/, hosts/, users/
    # Exports are collected from both registry.src and src
    # Hosts are collected from registry.src
    registry.src = ./..;

    # Auto-generate flake.nix from __inputs declarations
    flakeFile = {
      enable = true;
      coreInputs = import ./inputs.nix;
      description = "Albert's NixOS configuration using imp";
      outputsFile = "./flake";
    };

    # Export sinks configuration
    # Exports scanned from registry.src (../mod, etc.) and src (../outputs)
    exports.sinkDefaults = {
      "shared.*" = "mkMerge";
      "desktop.*" = "mkMerge";
    };

    # Auto-generate nixosConfigurations from __host declarations
    # Hosts scanned from registry.src (finds ../hosts)
    hosts = {
      enable = true;
      defaults = {
        system = "x86_64-linux";
        stateVersion = "24.11";
      };
    };
  };
}
