/**
  Shell init feature.

  Switches login shells to nushell with XDG-aware history.
*/
let
  mod =
    { pkgs, ... }:
    {
      environment.interactiveShellInit = ''
        if [ -z "''${XDG_STATE_HOME:-}" ]; then
          export XDG_STATE_HOME="$HOME/.local/state"
        fi
        export HISTFILE="$XDG_STATE_HOME/bash/history"
        mkdir -p "$(dirname "$HISTFILE")"
        if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "nu" && -z ''${BASH_EXECUTION_STRING} ]]
        then
          shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
          exec ${pkgs.nushell}/bin/nu $LOGIN_OPTION
        fi
      '';
    };
in
{
  __exports.shared.os.value = mod;
  __module = mod;
}
