/**
  KDL document formatting with tab indentation.
*/
{ pkgs, ... }:
let
  config = pkgs.writeText "kdlfmt.kdl" "use_tabs #true";
  wrapper = pkgs.writeShellScriptBin "kdlfmt-wrapper" ''
    exec ${pkgs.lib.getExe pkgs.kdlfmt} format --config ${config} "$@"
  '';
in
{
  settings.formatter.kdlfmt = {
    command = "${wrapper}/bin/kdlfmt-wrapper";
    includes = [ "*.kdl" ];
  };
}
