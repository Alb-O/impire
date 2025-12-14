/**
  XDG feature.

  Base directory layout and session environment.
*/
let
  mod =
    {
      lib,
      pkgs,
      config,
      ...
    }:
    let
      cfgHome = config.xdg.configHome;
      inherit (config.xdg) dataHome stateHome cacheHome;

      mkVars = prefix: mapping: lib.mapAttrs (_: value: "${prefix}/${value}") mapping;

      sessionVars =
        mkVars stateHome {
          HISTFILE = "bash/history";
          PYTHON_HISTORY = "python/python_history";
        }
        // mkVars dataHome {
          CARGO_HOME = "cargo";
          DOTNET_CLI_HOME = "dotnet";
          NB_DIR = "nb";
          GOPATH = "go";
          UNISON = "unison";
          PYTHONUSERBASE = "python";
        }
        // mkVars cacheHome {
          CUDA_CACHE_PATH = "nv";
          XCOMPOSECACHE = "X11/xcompose";
          NPM_CONFIG_CACHE = "npm";
          PYTHONPYCACHEPREFIX = "python";
        }
        // mkVars cfgHome {
          GTK2_RC_FILES = "gtk-2.0/gtkrc";
          NPM_CONFIG_INIT_MODULE = "npm/config/npm-init.js";
          NBRC_PATH = "nbrc";
          PYTHONSTARTUP = "python/pythonrc.py";
          XCOMPOSEFILE = "X11/xcompose";
        };
    in
    {
      nix = {
        enable = true;
        settings.use-xdg-base-directories = true;
        package = lib.mkDefault pkgs.nix;
      };

      home = {
        packages = lib.mkAfter (
          with pkgs;
          [
            kitty
            (writeShellApplication {
              name = "wget";
              text = ''
                exec -a "$0" "${wget}/bin/wget" --hsts-file="${dataHome}/wget-hsts" "$@"
              '';
            })
          ]
        );

        preferXdgDirectories = true;

        sessionVariables = lib.mkMerge [ sessionVars ];

        file = {
          "${cfgHome}/npm/config/.keep".text = "";
          "${stateHome}/python/.keep".text = "";
          "${dataHome}/python/.keep".text = "";
          "${dataHome}/pki/nssdb/keep".text = "";
          "${cacheHome}/python/.keep".text = "";
          "${stateHome}/bash/.keep".text = "";
        };
      };

      systemd.user.sessionVariables = lib.mkMerge [ sessionVars ];

      xdg = {
        enable = true;
        userDirs = {
          enable = true;
          createDirectories = true;
          desktop = "${config.home.homeDirectory}/desktop";
          documents = "${config.home.homeDirectory}/desktop/docs";
          download = "${config.home.homeDirectory}/desktop/dl";
          music = "${config.home.homeDirectory}/desktop/music";
          pictures = "${config.home.homeDirectory}/desktop/pics";
          videos = "${config.home.homeDirectory}/desktop/vids";
          templates = "${config.home.homeDirectory}/desktop/templates";
          publicShare = "${config.home.homeDirectory}/desktop/public";
        };
      };

      accounts = {
        calendar.basePath = lib.mkDefault "${dataHome}/calendar";
        contact.basePath = lib.mkDefault "${dataHome}/contacts";
      };

      targets.genericLinux.enable = lib.mkForce false;
      programs.man.enable = false;
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
