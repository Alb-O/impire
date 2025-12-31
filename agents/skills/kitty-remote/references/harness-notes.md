# Kitty Harness Notes

## Table of Contents

- Remote control entry points
- Launch modes
- Readiness and window discovery
- Failure signatures and evidence
- Input sequencing for modal apps
- Timing and stabilization

## Remote control entry points

- Use `kitty @` or `kitten @` interchangeably; both speak the same remote protocol.
- Target sockets with `--to unix:/abs/path.sock` or set `KITTY_LISTEN_ON=unix:/abs/path.sock` for the server.
- Add `--match id:<window-id>` when multiple windows exist and you need deterministic targeting.
- Treat `@ ls` as the canonical liveness check; it fails fast if the socket is gone.

## Launch modes

- Prefer `kitty +kitten panel --edge=background --focus-policy=not-allowed` on Wayland with layer-shell.
- Fall back to normal windows on X11/WSL: `kitty --listen-on unix:/abs/path.sock ...`.
- Use absolute socket paths; remove stale sockets before launch.
- Force backends with `KITTY_ENABLE_WAYLAND=0/1` and `LIBGL_ALWAYS_SOFTWARE=1` when rendering is flaky.
- Override panel auto-detection with `KITTY_TEST_USE_PANEL=0/1` in harnesses.

## Readiness and window discovery

- Wait for `@ ls` to succeed before sending input.
- `@ ls` returns JSON of OS windows -> tabs -> windows; window objects include `id`, `cwd`, and process info.
- When you need the window id, parse once after readiness and reuse it for `--match id:<id>`.

## Failure signatures and evidence

- `@ ls` fails with ENOENT/connection errors when the socket disappears (process exit or crash).
- `remote control is disabled` indicates `allow_remote_control=yes` was not set for the instance.
- Capture evidence on failure: `@ ls` stderr, `@ get-text --extent screen --ansi`, and app logs.
- If `send-text` succeeds but UI does not change, suspect input mode or key encoding.

## Input sequencing for modal apps

- Normalize mode with `ESC` before `:` commands in modal editors.
- Send `:` + command + `\n` as a single sequence or as discrete writes with short delays.
- Prefer explicit escape sequences for special keys; avoid relying on terminal shortcuts.

## Timing and stabilization

- Remote control sends bytes asynchronously; add minimal sleeps for UI render.
- For assertions, poll `get-text --extent screen` until the expected pattern appears.
- Avoid long sleeps by using targeted wait loops with timeouts and backoff.
