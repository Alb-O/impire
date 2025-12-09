/**
  MCP feature.

  Model Context Protocol servers for AI assistants.
*/
{
  __inputs = {
    mcp-servers-nix.url = "github:natsukium/mcp-servers-nix";
    mcp-servers-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  __overlays = [ "mcp-servers-nix.overlays.default" ];

  __functor =
    _: _:
    let
      mod =
        { pkgs, ... }:
        {
          home.packages = with pkgs; [
            mcp-nixos
          ];
        };
    in
    {
      __exports."hm.profile.shared".value = mod;
      __module = mod;
    };
}
