/**
  Zoxide feature.

  Smarter cd with jump navigation.
*/
let
  mod =
    { ... }:
    {
      programs.zoxide = {
        enable = true;
        options = [
          "--cmd"
          "cd"
        ];
      };
    };
in
{
  __exports."hm.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
