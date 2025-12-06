# OpenCode AI coding agent configuration
# MCP servers, agents, plugins, and model providers
{
  __inputs = {
    opencode-flake.url = "github:sst/opencode/v1.0.134";
    opencode-flake.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    { inputs, ... }:
    {
      __module =
        { pkgs, lib, ... }:
        let
          schema = "https://opencode.ai/config.json";
          settings = import ./settings.nix { };
          hasSettings = settings != { };
          renderedConfig = builtins.toJSON (
            {
              "$schema" = schema;
            }
            // settings
          );
        in
        {
          programs.opencode = {
            package = inputs.opencode-flake.packages."${pkgs.system}".default;
            enable = true;
          };
        }
        // lib.optionalAttrs hasSettings {
          xdg.configFile."opencode/config.json".text = renderedConfig;
        };
    };
}
