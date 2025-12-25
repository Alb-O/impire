---
name: kitty-remote
description: Control kitty terminal via remote protocol. Launch background panels/windows, send keys, capture screen output, manage sockets. Use when needing to do ad-hoc graphical terminal interactions or if user is reporting problems with TUI that can't easily be debugged using code/integration tests only.
compatibility: Requires kitty terminal. Wayland or X11 display session required.
metadata:
  author: Albert O'Shea
  version: "1.0"
---

# Kitty Remote Control

Control kitty terminal instances programmatically via the remote control protocol.

## Prerequisites

- kitty terminal installed and on PATH
- Remote control enabled (`allow_remote_control=yes` in kitty.conf or via `-o` flag)
- Active display session (Wayland or X11)

## Quick Reference

### Launch Methods

**Background panel (Wayland, non-disruptive):**
```bash
kitty +kitten panel --edge=background --listen-on unix:/path/to/socket.sock \
  -o allow_remote_control=yes --detach bash -c "command"
```

**Normal window (X11/fallback):**
```bash
kitty --listen-on unix:/path/to/socket.sock -o allow_remote_control=yes \
  --detach bash -c "command"
```

### Core Commands

| Command | Purpose |
|---------|---------|
| `kitty @ --to unix:SOCKET ls` | List windows, check if alive |
| `kitty @ --to unix:SOCKET send-text "text"` | Send raw text/escape sequences |
| `kitty @ --to unix:SOCKET get-text --extent screen` | Capture screen contents |
| `kitty @ --to unix:SOCKET close-window` | Close the window |

## Detailed Usage

### 1. Launching a Kitty Instance

#### Determine Launch Mode

Check environment to choose between panel and window mode:

```bash
# Panel mode works on native Wayland with layer-shell support
# Window mode works everywhere but may steal focus

if [[ -n "$WAYLAND_DISPLAY" && -z "$WSL_DISTRO_NAME" ]]; then
  # Try panel mode (background, non-disruptive)
  USE_PANEL=1
else
  # Use normal window
  USE_PANEL=0
fi
```

#### Launch with Socket

Always use absolute paths for sockets to avoid path resolution issues:

```bash
SOCKET="/tmp/kitty-session-$$.sock"
rm -f "$SOCKET"  # Clean up any stale socket

if [[ $USE_PANEL -eq 1 ]]; then
  kitty +kitten panel \
    --focus-policy=not-allowed \
    --edge=background \
    --listen-on "unix:$SOCKET" \
    -o allow_remote_control=yes \
    --detach \
    bash --noprofile --norc -lc "your-command-here"
else
  kitty \
    --listen-on "unix:$SOCKET" \
    -o allow_remote_control=yes \
    --detach \
    bash --noprofile --norc -lc "your-command-here"
fi
```

#### Wait for Socket

After launching, wait for the socket to become available:

```bash
wait_for_socket() {
  local socket="$1"
  local timeout="${2:-40}"  # 4 seconds default (40 * 100ms)

  for ((i=0; i<timeout; i++)); do
    if kitty @ --to "unix:$socket" ls &>/dev/null; then
      return 0
    fi
    sleep 0.1
  done
  return 1
}

if ! wait_for_socket "$SOCKET"; then
  echo "Failed to connect to kitty socket"
  exit 1
fi
```

### 2. Sending Input

#### Send Raw Text

```bash
kitty @ --to "unix:$SOCKET" send-text "Hello, World!"
```

#### Send Keys with Escape Sequences

For special keys, send their escape sequences:

```bash
# Enter key
kitty @ --to "unix:$SOCKET" send-text $'\n'

# Escape key
kitty @ --to "unix:$SOCKET" send-text $'\e'

# Arrow keys (standard ANSI)
kitty @ --to "unix:$SOCKET" send-text $'\e[A'  # Up
kitty @ --to "unix:$SOCKET" send-text $'\e[B'  # Down
kitty @ --to "unix:$SOCKET" send-text $'\e[C'  # Right
kitty @ --to "unix:$SOCKET" send-text $'\e[D'  # Left

# Ctrl+C
kitty @ --to "unix:$SOCKET" send-text $'\x03'
```

#### Common Key Sequences

| Key | Escape Sequence |
|-----|-----------------|
| Enter | `$'\n'` or `$'\r'` |
| Escape | `$'\e'` or `$'\x1b'` |
| Tab | `$'\t'` |
| Backspace | `$'\x7f'` |
| Ctrl+C | `$'\x03'` |
| Ctrl+D | `$'\x04'` |
| Up Arrow | `$'\e[A'` |
| Down Arrow | `$'\e[B'` |
| Right Arrow | `$'\e[C'` |
| Left Arrow | `$'\e[D'` |
| Home | `$'\e[H'` |
| End | `$'\e[F'` |
| Page Up | `$'\e[5~'` |
| Page Down | `$'\e[6~'` |
| F1-F4 | `$'\eOP'` through `$'\eOS'` |

### 3. Capturing Output

#### Get Screen Text

```bash
# Plain text (ANSI stripped)
kitty @ --to "unix:$SOCKET" get-text --extent screen

# With ANSI escape sequences preserved
kitty @ --to "unix:$SOCKET" get-text --extent screen --ansi
```

#### Capture and Process

```bash
capture_screen() {
  local socket="$1"
  kitty @ --to "unix:$socket" get-text --extent screen --ansi
}

# Wait for specific content
wait_for_content() {
  local socket="$1"
  local pattern="$2"
  local timeout="${3:-30}"

  for ((i=0; i<timeout*10; i++)); do
    if capture_screen "$socket" | grep -q "$pattern"; then
      return 0
    fi
    sleep 0.1
  done
  return 1
}

# Example: wait for prompt
wait_for_content "$SOCKET" '\$' 10
```

### 4. Session Management

#### Check if Instance is Alive

```bash
is_alive() {
  local socket="$1"
  kitty @ --to "unix:$socket" ls &>/dev/null
}

if is_alive "$SOCKET"; then
  echo "Kitty instance is running"
fi
```

#### Close Window

```bash
kitty @ --to "unix:$SOCKET" close-window
```

#### Get Window Information

```bash
# JSON output with window details
kitty @ --to "unix:$SOCKET" ls | jq '.[0].tabs[0].windows[0]'

# Get current working directory
kitty @ --to "unix:$SOCKET" ls | jq -r '.[0].tabs[0].windows[0].cwd'
```

### 5. Environment Variables

When launching kitty, these environment variables affect behavior:

| Variable | Effect |
|----------|--------|
| `KITTY_ENABLE_WAYLAND=0` | Force X11 backend |
| `KITTY_ENABLE_WAYLAND=1` | Force Wayland backend |
| `LIBGL_ALWAYS_SOFTWARE=1` | Use software rendering (useful for headless) |
| `KITTY_TEST_USE_PANEL=0/1` | Override panel mode detection |

## Common Patterns

### Run Command and Capture Output

```bash
run_and_capture() {
  local socket="$1"
  local command="$2"

  # Send command
  kitty @ --to "unix:$socket" send-text "$command"$'\n'

  # Wait briefly for execution
  sleep 0.5

  # Capture output
  kitty @ --to "unix:$socket" get-text --extent screen
}
```

### Interactive Session Template

```bash
#!/bin/bash
SOCKET="/tmp/kitty-interactive-$$.sock"
rm -f "$SOCKET"

# Launch
kitty --listen-on "unix:$SOCKET" -o allow_remote_control=yes --detach bash

# Wait for ready
sleep 1

# Run commands
kitty @ --to "unix:$SOCKET" send-text "cd /path/to/project"$'\n'
sleep 0.2
kitty @ --to "unix:$SOCKET" send-text "make test"$'\n'

# Wait for completion (adjust pattern as needed)
while ! kitty @ --to "unix:$SOCKET" get-text --extent screen | grep -q "tests passed"; do
  sleep 1
done

# Cleanup
kitty @ --to "unix:$SOCKET" close-window
rm -f "$SOCKET"
```

### Test Harness Pattern

```bash
#!/bin/bash
set -e

SOCKET="/tmp/kitty-test-$$.sock"
cleanup() { rm -f "$SOCKET"; kitty @ --to "unix:$SOCKET" close-window 2>/dev/null || true; }
trap cleanup EXIT

# Launch application under test
kitty --listen-on "unix:$SOCKET" -o allow_remote_control=yes --detach ./my-tui-app

# Wait for app to start
sleep 2

# Send input
kitty @ --to "unix:$SOCKET" send-text "i"  # Enter insert mode
kitty @ --to "unix:$SOCKET" send-text "Hello"
kitty @ --to "unix:$SOCKET" send-text $'\e'  # Exit insert mode

# Verify output
OUTPUT=$(kitty @ --to "unix:$SOCKET" get-text --extent screen)
if echo "$OUTPUT" | grep -q "Hello"; then
  echo "TEST PASSED"
else
  echo "TEST FAILED"
  exit 1
fi
```

## See Also

- [references/escape-codes.md](references/escape-codes.md) - Complete escape code reference
- [scripts/kitty-harness.sh](scripts/kitty-harness.sh) - Reusable test harness script
