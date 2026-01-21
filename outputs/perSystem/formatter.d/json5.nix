/**
  JSON5 formatting via prettier.
*/
{ pkgs, ... }:
let
  prettierPkg = pkgs.fetchurl {
    url = "https://registry.npmjs.org/prettier/-/prettier-3.4.2.tgz";
    sha256 = "sha256-2/fjUmSoE0fJqpGYkEIgHdY3H7IEZbzH0TjeY1qChAM=";
  };

  nodeModules = pkgs.stdenv.mkDerivation {
    name = "prettier-node-modules";
    buildInputs = [
      pkgs.gnutar
      pkgs.gzip
    ];
    unpackPhase = "true";
    installPhase = ''
      mkdir -p $out/node_modules/prettier
      tar -xzf ${prettierPkg} -C $out/node_modules/prettier --strip-components=1
    '';
  };

  script = pkgs.writeText "json5fmt.js" ''
    const fs = require('fs');
    const prettier = require('prettier');

    (async () => {
      for (const file of process.argv.slice(2)) {
        const content = fs.readFileSync(file, 'utf8');
        const formatted = await prettier.format(content, {
          parser: 'json5',
          tabWidth: 4,
          trailingComma: 'all',
        });
        fs.writeFileSync(file, formatted);
      }
    })();
  '';

  wrapper = pkgs.writeShellScriptBin "json5fmt" ''
    export NODE_PATH=${nodeModules}/node_modules
    exec ${pkgs.nodejs}/bin/node ${script} "$@"
  '';
in
{
  settings.formatter.json5 = {
    command = "${wrapper}/bin/json5fmt";
    includes = [ "*.json5" ];
  };
}
