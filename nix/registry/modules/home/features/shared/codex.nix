# codex feature - OpenAI Codex CLI
# AI-powered coding assistant
{ pkgs, ... }:
{
  programs.codex = {
    enable = true;
  };

  home.packages = with pkgs; [
    # codex likes to run adhoc python scripts
    python314
  ];
}
