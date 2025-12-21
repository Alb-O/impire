/**
  Helium Browser (Chromium fork) from github:Alb-O/helium-browser-flake.
  Configured as the default browser.
*/
{
  __inputs = {
    helium-browser.url = "github:Alb-O/helium-browser-flake";
    helium-browser.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _: _:
    let
      mod =
        {
          inputs,
          pkgs,
          config,
          ...
        }:
        let
          heliumPkg = inputs.helium-browser.packages."${pkgs.system}".helium-prerelease;
        in
        {
          home.packages = [ heliumPkg ];

          xdg.mimeApps = {
            enable = true;
            defaultApplications = {
              "text/html" = [ "helium.desktop" ];
              "text/xml" = [ "helium.desktop" ];
              "application/xhtml+xml" = [ "helium.desktop" ];
              "x-scheme-handler/http" = [ "helium.desktop" ];
              "x-scheme-handler/https" = [ "helium.desktop" ];
              "x-scheme-handler/about" = [ "helium.desktop" ];
              "x-scheme-handler/unknown" = [ "helium.desktop" ];
            };
          };

          home.sessionVariables = {
            BROWSER = "${heliumPkg}/bin/helium";
            DEFAULT_BROWSER = "${heliumPkg}/bin/helium";
          };
        };
    in
    {
      __exports.desktop.hm.value = mod;
      __module = mod;
    };
}
