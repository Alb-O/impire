# Formatter using imp-fmt
#
# Provides `nix fmt` with treefmt-nix, preconfigured with:
# - nixfmt (RFC-style Nix formatting)
# - mdformat (Markdown with GFM, frontmatter, footnotes)
#
# This uses the `__inputs`/`__functor` pattern for perSystem outputs:
# - `__inputs` declares dependencies (collected into flake.nix by imp-flake)
# - `__functor` receives perSystem args and returns the formatter derivation
#
# Usage:
#   nix fmt           # Format all files
#   nix fmt -- .      # Format current directory
#   nix fmt -- --help # Show treefmt options
{
  __inputs = {
    imp-fmt.url = "github:imp-nix/imp.fmt";
    imp-fmt.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor = _: { pkgs, inputs, ... }:
    inputs.imp-fmt.lib.make {
      inherit pkgs;
      treefmt-nix = inputs.imp-fmt.inputs.treefmt-nix;
    };
}
