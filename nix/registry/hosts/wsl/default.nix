# WSL host entry point
# Albert's Windows Subsystem for Linux configuration
{
  imp,
  inputs,
  registry,
  ...
}:
{
  imports = [
    inputs.nixos-wsl.nixosModules.default
    registry.mod.nixos.profiles.shared
    # Merge shared base config with WSL-specific config
    (imp.mergeConfigTrees [
      registry.hosts.shared.base.__path
      ./config
    ])
    inputs.home-manager.nixosModules.home-manager
    registry.hosts.wsl.home
  ];

  system.stateVersion = "24.11";
}
