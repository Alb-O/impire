/**
  WSL host entry point.

  Albert's Windows Subsystem for Linux configuration.
*/
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
      (imp.mergeConfigTrees [
        registry.hosts.shared.base.__path
        ./config
      ])
      inputs.home-manager.nixosModules.home-manager
      exports.shared.nixos.__module
    ]
    ++ imp.imports [
      registry.roles.nixos.home-wsl
    ];

  system.stateVersion = "24.11";
}
