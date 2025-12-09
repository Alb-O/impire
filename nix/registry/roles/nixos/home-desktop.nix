# NixOS helper: Home Manager setup for desktop/VM hosts
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
        exports.desktop.hm.__module
      ] ++ imp.imports [
        registry.users.albert
      ];
    };
  };
}
