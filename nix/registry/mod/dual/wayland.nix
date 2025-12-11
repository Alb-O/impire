/**
  Wayland feature.

  Wayland-first session defaults.
  HM: User session environment variables
  OS: System-wide environment variables and X server disable
*/
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

  hm =
    { lib, ... }:
    let
      mkDefaultEnv = lib.mapAttrs (_: lib.mkDefault) envDefaults;
    in
    {
      home.sessionVariables = mkDefaultEnv;
      systemd.user.sessionVariables = mkDefaultEnv;
    };
  os =
    { lib, ... }:
    let
      mkDefaultEnv = lib.mapAttrs (_: lib.mkDefault) envDefaults;
    in
    {
      environment.variables = mkDefaultEnv;
      environment.sessionVariables = mkDefaultEnv;
      services.xserver.enable = lib.mkDefault false;
    };
in
{
  __exports.desktop.hm.value = hm;
  __exports.desktop.os.value = os;
  __module = hm;
  __functor = _: hm;
}
