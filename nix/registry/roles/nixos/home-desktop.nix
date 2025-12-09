# NixOS helper: Home Manager setup for desktop/VM hosts
{
  inputs,
  imp,
  registry,
  ...
}:
{
  home-manager = {
    extraSpecialArgs = { inherit inputs imp registry; };
    useGlobalPkgs = true;
    useUserPackages = true;

    users.albert = {
      imports = imp.imports [
        registry.users.albert
        registry.mod.hm.profiles.desktop
      ];
    };
  };
}
