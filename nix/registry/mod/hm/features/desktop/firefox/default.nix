/**
  Firefox browser configuration with NUR extensions.

  This module declares `__inputs.nur` and applies the overlay locally via
  `pkgs.extend`, keeping the NUR dependency entirely self-contained. The
  alternative would be declaring `__overlays.nur` and aggregating it in a
  central `overlays.nix`, but that scatters the dependency across files.

  `pkgs.extend` creates a new package set with the overlay applied. Only
  `nurPkgs` sees NUR attributes; the original `pkgs` remains unchanged.
  This avoids polluting the global nixpkgs instance while still accessing
  `nur.repos.rycee.firefox-addons` for extension packages.
*/
{
  __inputs = {
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _:
    { inputs, ... }:
    {
      __module =
        {
          config,
          lib,
          pkgs,
          ...
        }:
        let
          inherit (config.home) username;
          homeDir = config.home.homeDirectory;

          # Apply NUR overlay locally; avoids needing central overlay aggregation
          nurPkgs = pkgs.extend inputs.nur.overlays.default;
          firefoxExtensions = with nurPkgs.nur.repos.rycee.firefox-addons; [
            darkreader
            ublock-origin
            bitwarden
            sponsorblock
            web-clipper-obsidian
            libredirect
            violentmonkey
            youtube-high-definition
            youtube-nonstop
          ];

          xdgDirs = lib.attrByPath [ "xdg" "userDirs" ] { } config;
          desktopDir =
            let
              rawDesktop = xdgDirs.desktop or "${homeDir}/Desktop";
            in
            lib.replaceStrings [ "$HOME" ] [ homeDir ] rawDesktop;
          downloadDir =
            let
              rawDownload = xdgDirs.download or "${homeDir}/Downloads";
            in
            lib.replaceStrings [ "$HOME" "$XDG_DESKTOP_DIR" ] [ homeDir desktopDir ] rawDownload;

          policiesConfig = import ./policies.nix { };
          prefsConfig = import ./prefs.nix { inherit lib downloadDir; };
          searchConfig = import ./search.nix { inherit lib pkgs; };
        in
        {
          programs.firefox = {
            enable = true;
            package = nurPkgs.firefox; # Must match the pkgs used by NUR extensions
            inherit (policiesConfig) policies;

            profiles.${username} = {
              id = 0;
              isDefault = true;
              path = username;
              settings = prefsConfig.profileSettings;
              search = searchConfig.searchConfig;
              extensions.packages = firefoxExtensions;
            };

            profiles.work = {
              id = 1;
              isDefault = false;
              path = "work";
              settings = prefsConfig.profileSettings;
              search = searchConfig.searchConfig;
              extensions.packages = firefoxExtensions;
            };
          };

          xdg.mimeApps = {
            enable = true;
            defaultApplications = {
              "text/html" = [ "firefox.desktop" ];
              "text/xml" = [ "firefox.desktop" ];
              "x-scheme-handler/http" = [ "firefox.desktop" ];
              "x-scheme-handler/https" = [ "firefox.desktop" ];
              "x-scheme-handler/about" = [ "firefox.desktop" ];
              "x-scheme-handler/unknown" = [ "firefox.desktop" ];
            };
          };

          home.sessionVariables = {
            BROWSER = "${config.programs.firefox.package}/bin/firefox";
            DEFAULT_BROWSER = "${config.programs.firefox.package}/bin/firefox";
          };
        };
    };
}
