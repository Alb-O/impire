# WSL host entry point
# Albert's Windows Subsystem for Linux configuration
{
  imp,
  inputs,
  exports,
  registry,
  ...
}:
{
  imports =
    [
      inputs.nixos-wsl.nixosModules.default
      # Merge shared base config with WSL-specific config
      (imp.mergeConfigTrees [
        registry.hosts.shared.base.__path
        ./config
      ])
      inputs.home-manager.nixosModules.home-manager
      # Role-based exports: shared NixOS modules only (no desktop)
      exports.shared.nixos.__module
    ]
    ++ imp.imports [
      registry.roles.nixos.home-wsl
    ];

  system.stateVersion = "24.11";
}
