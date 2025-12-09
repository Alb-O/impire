/**
  Visual Studio Code editor.
*/
let
  mod = { ... }: { programs.vscode.enable = true; };
in
{
  __exports."hm.profile.desktop".value = mod;
  __module = mod;
  __functor = _: mod;
}
