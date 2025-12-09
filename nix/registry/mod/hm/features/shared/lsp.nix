/**
  LSP feature.

  Language Server Protocol tooling for development.
*/
let
  mod =
    { pkgs, ... }:
    {
      home.packages = with pkgs; [
        nodePackages.typescript-language-server
        vscode-langservers-extracted
        tailwindcss-language-server
        marksman
        rust-analyzer
        nixd
        package-version-server
      ];
    };
in
{
  __exports."hm.profile.shared".value = mod;
  __module = mod;
  __functor = _: mod;
}
