/**
  NixOS-integrated Home Manager for desktop/VM hosts.

  Configures albert's HM within NixOS using shared + desktop exports.
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
        exports.desktop.hm.__module
      ] ++ imp.imports [
        registry.users.albert
      ];
    };
  };
}
