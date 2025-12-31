# Terminal Escape Codes Reference

Dense reference for escape sequences used with kitty remote control.

## Table of Contents

- Control Characters
- Ctrl Key Combinations
- CSI Sequences (Escape \[ ...)
- CSI Modifiers
- Alt Key Combinations
- Kitty Keyboard Protocol
- Practical Examples

## Control Characters

| Character | Hex  | Bash      | Description            |
| --------- | ---- | --------- | ---------------------- |
| NUL       | 0x00 | `$'\x00'` | Null                   |
| ETX       | 0x03 | `$'\x03'` | Ctrl+C (interrupt)     |
| EOT       | 0x04 | `$'\x04'` | Ctrl+D (EOF)           |
| BEL       | 0x07 | `$'\a'`   | Bell                   |
| BS        | 0x08 | `$'\b'`   | Backspace              |
| HT        | 0x09 | `$'\t'`   | Tab                    |
| LF        | 0x0A | `$'\n'`   | Line feed (newline)    |
| CR        | 0x0D | `$'\r'`   | Carriage return        |
| ESC       | 0x1B | `$'\e'`   | Escape                 |
| DEL       | 0x7F | `$'\x7f'` | Delete (backspace key) |

Notes:

- Backspace may be sent as `BS` (0x08) or `DEL` (0x7f) depending on termios and `stty erase`.
- `send-text` transmits raw bytes; prefer `$'...'` or `printf` for control codes.

## Ctrl Key Combinations

Ctrl+letter produces character code = letter - 64:

| Key     | Hex  | Bash      | Common Use            |
| ------- | ---- | --------- | --------------------- |
| Ctrl+A  | 0x01 | `$'\x01'` | Line start (readline) |
| Ctrl+B  | 0x02 | `$'\x02'` | Back char (readline)  |
| Ctrl+C  | 0x03 | `$'\x03'` | Interrupt (SIGINT)    |
| Ctrl+D  | 0x04 | `$'\x04'` | EOF / Delete char     |
| Ctrl+E  | 0x05 | `$'\x05'` | Line end (readline)   |
| Ctrl+F  | 0x06 | `$'\x06'` | Forward char          |
| Ctrl+G  | 0x07 | `$'\x07'` | Cancel                |
| Ctrl+H  | 0x08 | `$'\x08'` | Backspace             |
| Ctrl+K  | 0x0B | `$'\x0b'` | Kill to end           |
| Ctrl+L  | 0x0C | `$'\x0c'` | Clear screen          |
| Ctrl+N  | 0x0E | `$'\x0e'` | Next history          |
| Ctrl+P  | 0x10 | `$'\x10'` | Previous history      |
| Ctrl+R  | 0x12 | `$'\x12'` | Reverse search        |
| Ctrl+U  | 0x15 | `$'\x15'` | Kill line             |
| Ctrl+W  | 0x17 | `$'\x17'` | Kill word             |
| Ctrl+Z  | 0x1A | `$'\x1a'` | Suspend (SIGTSTP)     |
| Ctrl+\[ | 0x1B | `$'\e'`   | Escape                |

## CSI Sequences (Escape \[ ...)

### Cursor Movement

| Key        | Sequence   | Bash       |
| ---------- | ---------- | ---------- |
| Up         | ESC \[ A   | `$'\e[A'`  |
| Down       | ESC \[ B   | `$'\e[B'`  |
| Right      | ESC \[ C   | `$'\e[C'`  |
| Left       | ESC \[ D   | `$'\e[D'`  |
| Home       | ESC \[ H   | `$'\e[H'`  |
| End        | ESC \[ F   | `$'\e[F'`  |
| Home (alt) | ESC \[ 1 ~ | `$'\e[1~'` |
| End (alt)  | ESC \[ 4 ~ | `$'\e[4~'` |

### Editing Keys

| Key       | Sequence   | Bash       |
| --------- | ---------- | ---------- |
| Insert    | ESC \[ 2 ~ | `$'\e[2~'` |
| Delete    | ESC \[ 3 ~ | `$'\e[3~'` |
| Page Up   | ESC \[ 5 ~ | `$'\e[5~'` |
| Page Down | ESC \[ 6 ~ | `$'\e[6~'` |

### Function Keys

| Key | Sequence     | Bash        |
| --- | ------------ | ----------- |
| F1  | ESC O P      | `$'\eOP'`   |
| F2  | ESC O Q      | `$'\eOQ'`   |
| F3  | ESC O R      | `$'\eOR'`   |
| F4  | ESC O S      | `$'\eOS'`   |
| F5  | ESC \[ 1 5 ~ | `$'\e[15~'` |
| F6  | ESC \[ 1 7 ~ | `$'\e[17~'` |
| F7  | ESC \[ 1 8 ~ | `$'\e[18~'` |
| F8  | ESC \[ 1 9 ~ | `$'\e[19~'` |
| F9  | ESC \[ 2 0 ~ | `$'\e[20~'` |
| F10 | ESC \[ 2 1 ~ | `$'\e[21~'` |
| F11 | ESC \[ 2 3 ~ | `$'\e[23~'` |
| F12 | ESC \[ 2 4 ~ | `$'\e[24~'` |

## CSI Modifiers

For modified keys, add modifier code before the final character:

Format: `ESC [ 1 ; <modifier> <key>`

| Modifier       | Code |
| -------------- | ---- |
| Shift          | 2    |
| Alt            | 3    |
| Shift+Alt      | 4    |
| Ctrl           | 5    |
| Shift+Ctrl     | 6    |
| Alt+Ctrl       | 7    |
| Shift+Alt+Ctrl | 8    |

### Examples

| Key Combination | Sequence       | Bash         |
| --------------- | -------------- | ------------ |
| Shift+Up        | ESC \[ 1 ; 2 A | `$'\e[1;2A'` |
| Alt+Up          | ESC \[ 1 ; 3 A | `$'\e[1;3A'` |
| Ctrl+Up         | ESC \[ 1 ; 5 A | `$'\e[1;5A'` |
| Ctrl+Shift+Up   | ESC \[ 1 ; 6 A | `$'\e[1;6A'` |
| Shift+Right     | ESC \[ 1 ; 2 C | `$'\e[1;2C'` |
| Ctrl+Right      | ESC \[ 1 ; 5 C | `$'\e[1;5C'` |

## Alt Key Combinations

Alt+key is typically sent as ESC followed by the key:

| Key       | Sequence  | Bash      |
| --------- | --------- | --------- |
| Alt+a     | ESC a     | `$'\ea'`  |
| Alt+b     | ESC b     | `$'\eb'`  |
| Alt+f     | ESC f     | `$'\ef'`  |
| Alt+d     | ESC d     | `$'\ed'`  |
| Alt+Enter | ESC Enter | `$'\e\n'` |

Notes:

- Alt/meta encoding is ambiguous on many terminals; ESC prefix is the lowest-common-denominator.
- Some apps treat `Esc` + `key` with a timeout; send minimal delays if you need to distinguish.

## Kitty Keyboard Protocol

Kitty supports an extended keyboard protocol for unambiguous key encoding.

### Enable/Disable

```bash
# Enable (flags=1 for disambiguate)
printf '\e[>1u'

# Disable
printf '\e[<u'
```

### Extended Format

Format (press events): `CSI <codepoint> ; <modifiers> u`

Optional parameters may include event type (press/repeat/release) and alternate keycodes; see kitty
keyboard protocol docs if you need those fields. Modifiers use the same encoding as CSI modifiers
above (1=no modifiers, 2=Shift, 3=Alt, 4=Shift+Alt, 5=Ctrl, 6=Shift+Ctrl, 7=Alt+Ctrl, 8=Shift+Alt+Ctrl).

For most uses, the standard escape sequences above are sufficient.

## Practical Examples

### Send Vim-style Commands

```bash
SOCKET="/tmp/kitty.sock"

# Enter insert mode, type, exit
kitty @ --to "unix:$SOCKET" send-text "i"
kitty @ --to "unix:$SOCKET" send-text "Hello, World!"
kitty @ --to "unix:$SOCKET" send-text $'\e'

# Save and quit
kitty @ --to "unix:$SOCKET" send-text ":wq"
kitty @ --to "unix:$SOCKET" send-text $'\n'
```

### Navigate with Arrows

```bash
# Move up 3 times
for i in {1..3}; do
  kitty @ --to "unix:$SOCKET" send-text $'\e[A'
  sleep 0.05
done
```

### Send Ctrl+C to Interrupt

```bash
kitty @ --to "unix:$SOCKET" send-text $'\x03'
```

### Clear Screen

```bash
kitty @ --to "unix:$SOCKET" send-text $'\x0c'  # Ctrl+L
```
