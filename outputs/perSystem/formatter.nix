/**
  Formatter using imp.formatterLib

  Provides `nix fmt` with treefmt-nix, preconfigured with:
  - nixfmt (RFC-style Nix formatting)
  - mdformat (Markdown with GFM, frontmatter, footnotes)

  Usage:
    nix fmt           # Format all files
    nix fmt -- .      # Format current directory
    nix fmt -- --help # Show treefmt options
*/
{ pkgs, inputs, ... }:
inputs.imp.formatterLib.mk {
  inherit pkgs;
  treefmt-nix = inputs.imp.inputs.treefmt-nix;
}
