/**
  OpenCode feature.
  AI coding agent with MCP servers, agents, plugins, and model providers.
*/
{
  __inputs = {
    opencode-flake.url = "github:sst/opencode/v1.0.201";
    opencode-flake.inputs.nixpkgs.follows = "nixpkgs";
    oc-bin-flake.url = "github:bogorad/oc-bin-flake";
    oc-bin-flake.inputs.nixpkgs.follows = "nixpkgs";
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
        {
          programs.opencode = {
            package = inputs.oc-bin-flake.packages."${pkgs.system}".default;
            enable = true;
          };

          xdg.configFile = {
            "opencode/opencode.json".text = builtins.toJSON (
              { "$schema" = "https://opencode.ai/config.json"; } // import ./config.nix
            );
            "opencode/dcp.jsonc".source = ./dcp.jsonc;
            "opencode/skill" = {
              source = ../../../agents/skills;
              recursive = true;
            };
            "opencode/command" = {
              source = ../../../agents/commands;
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
