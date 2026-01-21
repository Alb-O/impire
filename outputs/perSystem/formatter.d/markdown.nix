/**
  Markdown formatter with GitHub Flavored Markdown support.

  Plugins:
  - mdformat-gfm: Tables, task lists, strikethrough
  - mdformat-frontmatter: YAML frontmatter preservation
  - mdformat-footnote: Footnote syntax
*/
{ pkgs, ... }:
let
  pkg = pkgs.mdformat.withPlugins (
    ps: with ps; [
      mdformat-gfm
      mdformat-frontmatter
      mdformat-footnote
    ]
  );
in
{
  settings.formatter.mdformat = {
    command = pkgs.lib.getExe pkg;
    options = [ "--number" ];
    includes = [ "*.md" ];
  };
}
