/**
  Rust formatting: rustfmt + cargo-sort for Cargo.toml.

  cargo-sort is wrapped to work with treefmt's file-based invocation
  (treefmt passes file paths, cargo-sort operates on directories).
*/
{ pkgs, ... }:
let
  wrapper = pkgs.writeShellScriptBin "cargo-sort-wrapper" ''
    set -euo pipefail
    opts=(); files=()
    while [[ $# -gt 0 ]]; do
      case "$1" in
        --*) opts+=("$1"); shift ;;
        *) files+=("$1"); shift ;;
      esac
    done
    for f in "''${files[@]}"; do
      ${pkgs.lib.getExe pkgs.cargo-sort} "''${opts[@]}" "$(dirname "$f")"
    done
  '';
in
{
  programs.rustfmt.enable = true;

  settings.formatter.cargo-sort = {
    command = "${wrapper}/bin/cargo-sort-wrapper";
    options = [ "--workspace" ];
    includes = [
      "Cargo.toml"
      "**/Cargo.toml"
    ];
  };
}
