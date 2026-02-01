/**
  Codex feature.

  OpenAI Codex CLI - AI-powered coding assistant.
  Uses codex-cli-nix flake for always up-to-date native Rust binary.
*/
{
  __inputs = {
    codex-cli-nix.url = "github:sadjow/codex-cli-nix";
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
            inputs.codex-cli-nix.packages.${pkgs.system}.default
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
