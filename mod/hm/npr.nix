/**
  Nix Profile Reinstall.

  Shell script to reinstall a nix profile package from the current directory.
*/
let
  mod =
    { pkgs, ... }:
    {
      home.packages = [
        (pkgs.writeShellScriptBin "npr" ''
          pkg="''${1:-default}"
          cwd="$PWD"

          # Find and remove any profile entry whose originalUrl contains cwd
          nix profile list --json | \
            ${pkgs.jq}/bin/jq -r --arg cwd "$cwd" '.elements | to_entries[] | select(.value.originalUrl // "" | contains($cwd)) | .key' | \
            xargs -r -I{} nix profile remove '{}'

          nix profile add ".#''${pkg}"
        '')
      ];
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
