/**
  tm feature.

  Tmux-based process manager for running detached commands with session management.
*/
let
  mod =
    { pkgs, ... }:
    let
      tm = pkgs.writeShellScriptBin "tm" ''
            set -euo pipefail
            
            TMUX="${pkgs.tmux}/bin/tmux"
            
            usage() {
              cat >&2 <<'EOF'
        tm — tmux session helper

        Usage:
          tm [--help|-h]
          tm <cmd> [args...]          Start <cmd> in a detached tmux session
          tm attach <session>         Attach to a session
          tm tail <session>           Tail the latest log for <session>
          tm log <session>            Print the latest log path for <session>
          tm ps [session]             List tmux sessions (all or matching)
          tm kill <session>           Kill tmux session
          tm clean                    Remove dead sessions
          tm prune-logs <days>        Delete logs older than <days>

        Sessions are named: tm-<cmd>-<timestamp>
        Logs: $XDG_STATE_HOME/tm/<session>.log (fallback: $HOME/.local/state)
        EOF
            }

            if [ "$#" -lt 1 ]; then
              usage
              exit 2
            fi

            state_home="''${XDG_STATE_HOME:-$HOME/.local/state}"
            log_dir="$state_home/tm"
            mkdir -p "$log_dir"

            # help flag
            if [ "''${1-}" = "-h" ] || [ "''${1-}" = "--help" ]; then
              usage
              exit 0
            fi

            # attach subcommand
            if [ "$1" = "attach" ] || [ "$1" = "a" ]; then
              shift
              if [ "$#" -lt 1 ]; then
                echo "tm: missing <session> for attach" >&2
                usage
                exit 2
              fi
              session="$1"
              if ! $TMUX has-session -t "$session" 2>/dev/null; then
                echo "tm: session '$session' not found" >&2
                exit 1
              fi
              exec $TMUX attach-session -t "$session"
            fi

            # tail subcommand
            if [ "$1" = "tail" ] || [ "$1" = "t" ]; then
              shift
              if [ "$#" -lt 1 ]; then
                echo "tm: missing <session> for tail" >&2
                usage
                exit 2
              fi
              session="$1"
              logfile="$log_dir/$session.log"
              if [ ! -f "$logfile" ]; then
                echo "tm: no log for session '$session'" >&2
                exit 1
              fi
              echo "tm: tailing $logfile" >&2
              exec ${pkgs.coreutils}/bin/tail -n 100 -f "$logfile"
            fi

            # log subcommand
            if [ "$1" = "log" ]; then
              shift
              if [ "$#" -lt 1 ]; then
                echo "tm: missing <session> for log" >&2
                usage
                exit 2
              fi
              session="$1"
              logfile="$log_dir/$session.log"
              if [ ! -f "$logfile" ]; then
                echo "tm: no log for session '$session'" >&2
                exit 1
              fi
              printf '%s\n' "$logfile"
              exit 0
            fi

            # ps subcommand
            if [ "$1" = "ps" ]; then
              shift
              filter="''${1:-}"
              if [ -n "$filter" ]; then
                $TMUX list-sessions 2>/dev/null | ${pkgs.gnugrep}/bin/grep "^tm-$filter" || true
              else
                $TMUX list-sessions 2>/dev/null | ${pkgs.gnugrep}/bin/grep "^tm-" || true
              fi
              exit 0
            fi

            # kill subcommand
            if [ "$1" = "kill" ]; then
              shift
              if [ "$#" -lt 1 ]; then
                echo "tm: missing <session> for kill" >&2
                usage
                exit 2
              fi
              session="$1"
              if ! $TMUX has-session -t "$session" 2>/dev/null; then
                echo "tm: session '$session' not found" >&2
                exit 1
              fi
              $TMUX kill-session -t "$session"
              echo "tm: killed session '$session'"
              exit 0
            fi

            # clean subcommand
            if [ "$1" = "clean" ]; then
              # Remove log files for sessions that no longer exist
              sessions=$($TMUX list-sessions -F "#{session_name}" 2>/dev/null | ${pkgs.gnugrep}/bin/grep "^tm-" || true)
              cleaned=0
              for logfile in "$log_dir"/tm-*.log; do
                [ -f "$logfile" ] || continue
                session=$(${pkgs.coreutils}/bin/basename "$logfile" .log)
                if ! echo "$sessions" | ${pkgs.gnugrep}/bin/grep -q "^$session$"; then
                  ${pkgs.coreutils}/bin/rm -f "$logfile"
                  cleaned=$((cleaned+1))
                fi
              done
              echo "tm: cleaned $cleaned stale log files" >&2
              exit 0
            fi

            # prune-logs subcommand
            if [ "$1" = "prune-logs" ]; then
              shift
              if [ "$#" -lt 1 ]; then
                echo "tm: missing <days> for prune-logs" >&2
                usage
                exit 2
              fi
              days="$1"
              ${pkgs.findutils}/bin/find "$log_dir" -maxdepth 1 -type f -name 'tm-*.log' -mtime "+$days" -print -delete 2>/dev/null || true
              exit 0
            fi

            # default: run a command in a new tmux session
            cmd="$1"; shift || true
            case "$cmd" in (-*) echo "tm: invalid command '$cmd' (starts with '-')" >&2; usage; exit 2 ;; esac
            
            if ! command -v "$cmd" >/dev/null 2>&1; then
              echo "tm: command not found: $cmd" >&2
              exit 127
            fi
            
            cmd_name=$(${pkgs.coreutils}/bin/basename "$cmd")
            ts=$(${pkgs.coreutils}/bin/date +%Y%m%d-%H%M%S)
            session="tm-$cmd_name-$ts"
            logfile="$log_dir/$session.log"
            
            # Create new detached session with logging
            $TMUX new-session -d -s "$session" "$cmd $* 2>&1 | ${pkgs.coreutils}/bin/tee $logfile"
            
            echo "tm: started '$cmd' in session '$session'"
            echo "tm: log: $logfile"
            echo "tm: attach with: tm attach $session"
      '';
    in
    {
      home.packages = [ tm ];
    };
in
{
  __exports.shared.hm.value = mod;
  __module = mod;
}
