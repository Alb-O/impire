# Emacs feature - using emacs-overlay for emacs-unstable-pgtk
# ARCHIVED: Not currently in use
{
  __inputs = {
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    emacs-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  __overlays = {
    emacs = "emacs-overlay.overlays.emacs";
  };

  __functor =
    _:
    { inputs, ... }:
    {
      __module =
        { pkgs, ... }:
        let
          emacsPackage =
            with pkgs;
            (emacsWithPackagesFromUsePackage {
              package = emacs-unstable-pgtk;
              config = ./emacs.org;
              defaultInitFile = true;
              extraEmacsPackages =
                epkgs:
                (with epkgs; [
                  use-package
                  which-key
                ]);
            });
        in
        {
          services.emacs = {
            enable = true;
            package = emacsPackage;
            socketActivation.enable = true;
            client.enable = true;
            startWithUserSession = true;
          };

          programs.emacs = {
            enable = true;
            package = emacsPackage;
          };
        };
    };
}
