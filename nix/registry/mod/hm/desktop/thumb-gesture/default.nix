/**
  Thumb Gesture Daemon - Maps MX Master 4 thumb wheel to Niri's smooth horizontal panning.

  This daemon listens to thumb wheel events from Solaar and simulates the
  Mod+MiddleMouse+Drag gesture using ydotool for smooth column navigation in Niri.
*/
let
  mod =
    { pkgs, lib, ... }:
    let
      python-with-evdev = pkgs.python3.withPackages (ps: with ps; [ evdev ]);

      thumb-gesture-script = pkgs.writeShellScriptBin "thumb-gesture-daemon" ''
        exec ${python-with-evdev}/bin/python3 ${./thumb-gesture-daemon.py}
      '';
    in
    {
      home.packages = [
        pkgs.ydotool
        pkgs.socat
        thumb-gesture-script
      ];

      # Systemd user service for the thumb gesture daemon
      systemd.user.services.thumb-gesture-daemon = {
        Unit = {
          Description = "Thumb Gesture Daemon for Niri";
          After = [ "graphical-session.target" "ydotoold.service" ];
          Wants = [ "ydotoold.service" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${thumb-gesture-script}/bin/thumb-gesture-daemon";
          Restart = "on-failure";
          RestartSec = 3;
          # Ensure ydotool can find its socket
          Environment = [ "YDOTOOL_SOCKET=/tmp/.ydotool_socket" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };

      # ydotool daemon service (required for ydotool to work)
      systemd.user.services.ydotoold = {
        Unit = {
          Description = "ydotool daemon";
          After = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.ydotool}/bin/ydotoold -p /tmp/.ydotool_socket -P 0666";
          Restart = "on-failure";
          Environment = [ "YDOTOOL_SOCKET=/tmp/.ydotool_socket" ];
        };
        Install.WantedBy = [ "graphical-session.target" ];
      };
    };
in
{
  #__exports.desktop.hm.value = mod;
  #__module = mod;
}
