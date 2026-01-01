# imp.gits config for nushell submodule sparse checkout
# This config lives outside the submodule to keep it pristine
{
  target = "nushell";
  sparse = {
    mode = "no-cone";
    patterns = [
      "/book/"
      "/cookbook/"
      "/commands/"
      "/lang-guide/"
      "/README.md"
    ];
  };
}
