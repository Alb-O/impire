/**
  Claude Code feature.

  Anthropic's Claude Code CLI - AI-powered coding assistant.
  Uses claude-code-nix flake for always up-to-date native binary.
*/
{
  __inputs = {
    claude-code-nix.url = "github:sadjow/claude-code-nix";
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
        {
          home.packages = [
            inputs.claude-code-nix.packages.${pkgs.system}.default
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
