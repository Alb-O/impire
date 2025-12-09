/**
  Kakoune modal editor with LSP and tree-sitter.
*/
let
  mod =
    { lib, pkgs, ... }:
    {
      programs.kakoune = {
        enable = true;
        defaultEditor = true;
      };

      xdg.configFile = {
        "kak/kakrc".source = lib.mkForce ./kakrc;
        "kak/plugins" = {
          source = ./plugins;
          recursive = true;
        };
        "kak/colors" = {
          source = ./colors;
          recursive = true;
        };
        "kak/filetypes" = {
          source = ./filetypes;
          recursive = true;
        };
      };

      home.packages = with pkgs; [
        kakoune-lsp
        kak-tree-sitter
        kamp
      ];
    };
in
{
  __exports."hm.profile.desktop".value = mod;
  __module = mod;
  __functor = _: mod;
}
