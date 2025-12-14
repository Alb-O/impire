/**
  awww - Wayland wallpaper daemon with smooth transitions.
*/
{
  __inputs = {
    awww.url = "git+https://codeberg.org/LGFae/awww";
    awww.inputs.nixpkgs.follows = "nixpkgs";
  };

  __functor =
    _: _:
    let
      mod =
        { inputs, pkgs, ... }:
        let
          awwwPkg = inputs.awww.packages."${pkgs.system}".default;
          wallpaper = ./solarized-light-nixos.png;
        in
        {
          home.packages = [ awwwPkg ];

          systemd.user.services.awww-daemon = {
            Unit = {
              Description = "awww wallpaper daemon";
              PartOf = [ "graphical-session.target" ];
              After = [ "graphical-session.target" ];
            };
            Service = {
              ExecStart = "${awwwPkg}/bin/awww-daemon";
              ExecStartPost = "${awwwPkg}/bin/awww img ${wallpaper}";
              Restart = "on-failure";
              RestartSec = 5;
            };
            Install = {
              WantedBy = [ "graphical-session.target" ];
            };
          };
        };
    in
    {
      __exports.desktop.hm.value = mod;
      __module = mod;
    };
}
