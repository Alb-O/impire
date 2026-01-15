/**
  Claude Code feature.

  Anthropic's Claude Code CLI - AI-powered coding assistant.
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
          ...
        }:
        let
          # Custom overlay functor: apply claude-code from nixpkgs master
          masterPkgs = import inputs.nixpkgs-master {
            inherit (pkgs) system;
            config.allowUnfree = true;
          };
        in
        {
          home.packages = [
            masterPkgs.claude-code
          ];

          home.file = {
            ".claude/skills" = {
              source = ../../agents/skills;
              recursive = true;
            };
            ".claude/commands" = {
              source = ../../agents/commands;
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
