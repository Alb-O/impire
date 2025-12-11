/**
  Visual Studio Code editor.
*/
let
  mod =
    { ... }:
    {
      programs.vscode.enable = true;
    };
in
{
  __exports."desktop.hm".value = mod;
  __module = mod;
}
