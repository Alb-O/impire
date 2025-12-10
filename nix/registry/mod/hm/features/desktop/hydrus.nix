/**
  Hydrus client wrapper with HiDPI scaling.
*/
let
  mod =
    { pkgs, ... }:
    let
      # Apply overlay to bypass hydrus check phase
      pkgs' = pkgs.extend (
        final: prev: {
          hydrus = prev.hydrus.overrideAttrs (oldAttrs: {
            doCheck = false;
          });
        }
      );

      hydrusClient = pkgs.writeShellScriptBin "hydrus-client" ''
        set -euo pipefail

        export QT_ENABLE_HIGHDPI_SCALING="1"
        export QT_SCALE_FACTOR="1.5"

        XDG_DATA_HOME="''${XDG_DATA_HOME:-$HOME/.local/share}"
        exec -a "$0" "${pkgs'.hydrus}/bin/hydrus-client" --db_dir "$XDG_DATA_HOME/hydrus" "$@"
      '';
    in
    {
      home.packages = [ hydrusClient ];
    };
in
{
  __exports."desktop.hm".value = mod;
  __module = mod;
  __functor = _: mod;
}
