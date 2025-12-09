/**
  Wayland session environment variables for HM.
*/
let
  mod =
    { lib, ... }:
    let
      envDefaults = {
        QT_QPA_PLATFORM = "wayland;xcb";
        GDK_BACKEND = "wayland";
        SDL_VIDEODRIVER = "wayland";
        CLUTTER_BACKEND = "wayland";
        MOZ_ENABLE_WAYLAND = "1";
        XDG_SESSION_TYPE = "wayland";
        NIXOS_OZONE_WL = "1";
        WAYLAND_DISPLAY = "\${WAYLAND_DISPLAY:-wayland-1}";
      };

      mkDefaultEnv = lib.mapAttrs (_: lib.mkDefault) envDefaults;
    in
    {
      home.sessionVariables = mkDefaultEnv;
      systemd.user.sessionVariables = mkDefaultEnv;
    };
in
{
  __exports."desktop.hm".value = mod;
  __module = mod;
  __functor = _: mod;
}
