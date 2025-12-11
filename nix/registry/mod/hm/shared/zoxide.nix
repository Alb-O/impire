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
  __exports.shared.hm.value = mod;
  __module = mod;
}
