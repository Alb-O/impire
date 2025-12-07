# Kakoune feature - modal editor with LSP and tree-sitter
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
}
