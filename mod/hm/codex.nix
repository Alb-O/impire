/**
  Codex feature.

  OpenAI Codex CLI - AI-powered coding assistant.
*/
let
  mod =
    { pkgs, ... }:
    {
      programs.codex = {
        enable = true;
      };

      home.packages = with pkgs; [
        python314
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
}
