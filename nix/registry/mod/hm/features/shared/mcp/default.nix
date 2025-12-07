# MCP feature - Model Context Protocol servers
# Provides mcp-nixos and context7 for AI assistants
{
  __inputs = {
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
    mcp-servers-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  __overlays = [ "mcp-servers-nix.overlays.default" ];

  __functor =
    _:
    { inputs, ... }:
    {
      __module =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            mcp-nixos
          ];
        };
    };
}
