/**
  Codex feature.

  OpenAI Codex CLI - AI-powered coding assistant.
  Uses nixpkgs master branch for the latest package version.
*/
{
  __inputs = {
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
  };

  __functor =
    _: _:
    let
      mod =
        {
          inputs,
          pkgs,
          lib,
          ...
        }:
        let
          masterPkgs = import inputs.nixpkgs-master {
            inherit (pkgs) system;
          };
        in
        {
          home.packages = [
            masterPkgs.codex
            pkgs.python314
          ];

          home.file = {
            ".codex/skills" = {
              source = ../../agents/skills;
              recursive = true;
            };
          };
        };
    in
    {
      __exports.shared.hm.value = mod;
      __module = mod;
    };
}
