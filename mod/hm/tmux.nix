/**
  Tmux feature.

  Terminal multiplexer for agents/interactive usage.
*/
let
  mod =
    { ... }:
    {
      programs.tmux = {
        enable = true;
      };
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
