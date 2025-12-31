#!/usr/bin/env bash
# kitty-harness.sh - Reusable kitty remote control harness
#
# Usage:
#   source kitty-harness.sh
#   kitty_launch "my-app --args"
#   kitty_send_text "hello"
#   kitty_send_key "Enter"
#   output=$(kitty_capture)
#   kitty_close

set -euo pipefail

# Configuration
KITTY_BIN="${KITTY_BIN:-kitty}"
KITTY_REMOTE_BIN="${KITTY_REMOTE_BIN:-kitty}"
KITTY_SOCKET="${KITTY_SOCKET:-}"
KITTY_LAUNCH_TIMEOUT="${KITTY_LAUNCH_TIMEOUT:-40}"  # iterations of 100ms
KITTY_USE_PANEL="${KITTY_USE_PANEL:-auto}"

# Internal state
_KITTY_SESSION_NAME=""

#######################################
# Detect if panel mode should be used
# Returns: 0 if panel mode, 1 if window mode
#######################################
_kitty_should_use_panel() {
  case "$KITTY_USE_PANEL" in
    1|true|yes) return 0 ;;
    0|false|no) return 1 ;;
  esac
  
  # Auto-detect
  # Panel requires Wayland with layer-shell (not available in WSL)
  if [[ -n "${WSL_DISTRO_NAME:-}" || -n "${WSL_INTEROP:-}" ]]; then
    return 1
  fi
  
  if [[ -n "${WAYLAND_DISPLAY:-}" ]]; then
    if [[ "${XDG_SESSION_TYPE:-}" == "wayland" ]]; then
      return 0
    fi
  fi
  
  return 1
}

#######################################
# Generate unique session name
#######################################
_kitty_session_name() {
  echo "kitty-harness-$$-$RANDOM"
}

#######################################
# Run kitty remote control command
# Arguments:
#   ... - Remote control subcommand and args
#######################################
_kitty_remote() {
  "$KITTY_REMOTE_BIN" @ --to "unix:$KITTY_SOCKET" "$@"
}

#######################################
# Launch a kitty instance
# Arguments:
#   $1 - Command to run (default: bash)
#   $2 - Working directory (default: current)
# Sets: KITTY_SOCKET
#######################################
kitty_launch() {
  local command="${1:-bash}"
  local workdir="${2:-$(pwd)}"
  
  _KITTY_SESSION_NAME="$(_kitty_session_name)"
  KITTY_SOCKET="/tmp/${_KITTY_SESSION_NAME}.sock"
  
  # Clean up any stale socket
  rm -f "$KITTY_SOCKET"
  
  if _kitty_should_use_panel; then
    "$KITTY_BIN" +kitten panel \
      --focus-policy=not-allowed \
      --edge=background \
      --listen-on "unix:$KITTY_SOCKET" \
      --class "$_KITTY_SESSION_NAME" \
      -o allow_remote_control=yes \
      --detach \
      bash --noprofile --norc -lc "cd '$workdir' && $command"
  else
    # Set environment for X11/software rendering fallback
    KITTY_ENABLE_WAYLAND="${KITTY_ENABLE_WAYLAND:-0}" \
    LIBGL_ALWAYS_SOFTWARE="${LIBGL_ALWAYS_SOFTWARE:-1}" \
    "$KITTY_BIN" \
      --listen-on "unix:$KITTY_SOCKET" \
      --class "$_KITTY_SESSION_NAME" \
      -o allow_remote_control=yes \
      --detach \
      bash --noprofile --norc -lc "cd '$workdir' && $command"
  fi
  
  # Wait for socket to be ready
  kitty_wait_ready
}

#######################################
# Wait for kitty to be ready
# Returns: 0 on success, 1 on timeout
#######################################
kitty_wait_ready() {
  local i
  for ((i=0; i<KITTY_LAUNCH_TIMEOUT; i++)); do
    if _kitty_remote ls &>/dev/null; then
      return 0
    fi
    sleep 0.1
  done
  echo "ERROR: Timeout waiting for kitty socket: $KITTY_SOCKET" >&2
  return 1
}

#######################################
# Check if kitty instance is alive
# Returns: 0 if alive, 1 if not
#######################################
kitty_is_alive() {
  [[ -n "$KITTY_SOCKET" ]] && _kitty_remote ls &>/dev/null
}

#######################################
# Send raw text to kitty
# Arguments:
#   $1 - Text to send
#######################################
kitty_send_text() {
  local text="$1"
  _kitty_remote send-text "$text"
  sleep 0.02  # Small delay for processing
}

#######################################
# Send a key by name
# Arguments:
#   $1 - Key name (Enter, Escape, Up, Down, Left, Right, Tab, etc.)
#######################################
kitty_send_key() {
  local key="$1"
  local seq
  
  case "$key" in
    Enter|Return)    seq=$'\n' ;;
    Escape|Esc)      seq=$'\e' ;;
    Tab)             seq=$'\t' ;;
    Backspace)       seq=$'\x7f' ;;
    Delete)          seq=$'\e[3~' ;;
    Up)              seq=$'\e[A' ;;
    Down)            seq=$'\e[B' ;;
    Right)           seq=$'\e[C' ;;
    Left)            seq=$'\e[D' ;;
    Home)            seq=$'\e[H' ;;
    End)             seq=$'\e[F' ;;
    PageUp)          seq=$'\e[5~' ;;
    PageDown)        seq=$'\e[6~' ;;
    Insert)          seq=$'\e[2~' ;;
    F1)              seq=$'\eOP' ;;
    F2)              seq=$'\eOQ' ;;
    F3)              seq=$'\eOR' ;;
    F4)              seq=$'\eOS' ;;
    F5)              seq=$'\e[15~' ;;
    F6)              seq=$'\e[17~' ;;
    F7)              seq=$'\e[18~' ;;
    F8)              seq=$'\e[19~' ;;
    F9)              seq=$'\e[20~' ;;
    F10)             seq=$'\e[21~' ;;
    F11)             seq=$'\e[23~' ;;
    F12)             seq=$'\e[24~' ;;
    Ctrl-C)          seq=$'\x03' ;;
    Ctrl-D)          seq=$'\x04' ;;
    Ctrl-L)          seq=$'\x0c' ;;
    Ctrl-Z)          seq=$'\x1a' ;;
    *)
      echo "ERROR: Unknown key: $key" >&2
      return 1
      ;;
  esac
  
  kitty_send_text "$seq"
}

#######################################
# Send Alt+key combination
# Arguments:
#   $1 - Character to combine with Alt
#######################################
kitty_send_alt() {
  local char="$1"
  kitty_send_text $'\e'"$char"
}

#######################################
# Send Ctrl+key combination
# Arguments:
#   $1 - Character (a-z) to combine with Ctrl
#######################################
kitty_send_ctrl() {
  local char="$1"
  local code
  
  # Convert to uppercase and get control code
  char="${char^^}"
  code=$(( $(printf '%d' "'$char") - 64 ))
  
  if ((code < 1 || code > 26)); then
    echo "ERROR: Invalid Ctrl key: $char" >&2
    return 1
  fi
  
  kitty_send_text "$(printf "\\x$(printf '%02x' "$code")")"
}

#######################################
# Capture screen contents
# Arguments:
#   --ansi - Include ANSI escape sequences
# Outputs: Screen text
#######################################
kitty_capture() {
  local ansi_flag=""
  if [[ "${1:-}" == "--ansi" ]]; then
    ansi_flag="--ansi"
  fi
  _kitty_remote get-text --extent screen $ansi_flag
}

#######################################
# Wait for screen to contain pattern
# Arguments:
#   $1 - Pattern (grep -E regex)
#   $2 - Timeout in seconds (default: 10)
# Returns: 0 if found, 1 if timeout
#######################################
kitty_wait_for() {
  local pattern="$1"
  local timeout="${2:-10}"
  local i
  
  for ((i=0; i<timeout*10; i++)); do
    if kitty_capture | grep -qE "$pattern"; then
      return 0
    fi
    sleep 0.1
  done
  return 1
}

#######################################
# Close kitty window and clean up
#######################################
kitty_close() {
  if [[ -n "$KITTY_SOCKET" ]]; then
    _kitty_remote close-window 2>/dev/null || true
    rm -f "$KITTY_SOCKET"
    KITTY_SOCKET=""
    _KITTY_SESSION_NAME=""
  fi
}

#######################################
# Get window information as JSON
#######################################
kitty_info() {
  _kitty_remote ls
}

#######################################
# Dump remote state for debugging
# Arguments:
#   $1 - Optional output directory
#######################################
kitty_dump_state() {
  local out_dir="${1:-}"
  if [[ -n "$out_dir" ]]; then
    mkdir -p "$out_dir"
    _kitty_remote ls > "$out_dir/kitty-ls.json" 2>&1 || true
    _kitty_remote get-text --extent screen --ansi > "$out_dir/kitty-screen.ansi" 2>&1 || true
  else
    _kitty_remote ls || true
    _kitty_remote get-text --extent screen --ansi || true
  fi
}

#######################################
# Pause briefly (for compositor/timing)
#######################################
kitty_pause() {
  local ms="${1:-300}"
  sleep "$(echo "scale=3; $ms/1000" | bc)"
}

# Set up cleanup trap if running as script
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  trap kitty_close EXIT
fi
