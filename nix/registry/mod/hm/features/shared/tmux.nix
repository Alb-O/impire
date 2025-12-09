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
  __exports."hm.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
