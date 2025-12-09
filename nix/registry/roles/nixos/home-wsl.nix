/**
  NixOS Home Manager setup for WSL host.
*/
{
  inputs,
  exports,
  imp,
  registry,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs exports imp registry; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.albert = {
      imports = [
        exports.shared.hm.__module
      ] ++ imp.imports [
        registry.users.albert
      ];
    };
  };
}
