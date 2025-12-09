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
    };
in
{
  __exports."hm.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
