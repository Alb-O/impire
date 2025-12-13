/**
  Desktop utilities bundle (hyprpicker, libinput, solaar).
*/
let
  mod =
    { pkgs, ... }:
    let
      # Use latest solaar from GitHub (nixpkgs version is outdated)
      solaar-latest = pkgs.solaar.overrideAttrs (oldAttrs: rec {
        version = "1.1.18";
        src = pkgs.fetchFromGitHub {
          owner = "pwr-Solaar";
          repo = "Solaar";
          tag = version;
          hash = "sha256-K1mh1FgdYe1yioczUoOb7rrI0laq+1B4TLlblerMyHE=";
        };
        # 1.1.18 uses PATH-based getfacl lookup instead of hardcoded /usr/bin/getfacl
        preConfigure = "";
        preFixup =
          (oldAttrs.preFixup or "")
          + ''
            makeWrapperArgs+=(--prefix PATH : "${pkgs.acl}/bin")
          '';
      });
    in
    {
      home.packages = with pkgs; [
        hyprpicker
        libinput
        solaar-latest
      ];

      # Solaar systemd user service - runs in tray on startup
      systemd.user.services.solaar = {
        Unit = {
          Description = "Solaar - Logitech device manager";
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${solaar-latest}/bin/solaar --window=hide";
          Restart = "on-failure";
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
in
{
  __exports.desktop.hm.value = mod;
  __module = mod;
}
