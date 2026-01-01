# Testing and Debugging Nushell Plugins

## Development Workflow

### 1. Initial Development

```bash
cargo new nu_plugin_myplugin
cd nu_plugin_myplugin
cargo add nu-plugin nu-protocol
```

### 2. Build and Test Locally

```bash
cargo build
plugin add target/debug/nu_plugin_myplugin
plugin use myplugin
"test input" | myplugin
```

### 3. Iterate
```bash
cargo build
plugin rm myplugin
plugin add target/debug/nu_plugin_myplugin
plugin use myplugin
```

### 4. Release Build
```bash
cargo build --release
cargo install --path . --locked
plugin add ~/.cargo/bin/nu_plugin_myplugin  # .exe on Windows
plugin use myplugin
```

## Automated Testing

Add test dependency:
```toml
[dev-dependencies]
nu-plugin-test-support = "0.109.1"
```
```rust
#[cfg(test)]
mod tests {
    use super::*;
    use nu_plugin_test_support::PluginTest;
    use nu_protocol::ShellError;

    #[test]
    fn test_my_command() -> Result<(), ShellError> {
        let mut plugin_test = PluginTest::new("myplugin", MyPlugin.into())?;

        // Test examples defined in signature
        plugin_test.test_examples(&MyCommand)?;

        Ok(())
    }

    #[test]
    fn test_specific_case() -> Result<(), ShellError> {
        let plugin_test = PluginTest::new("myplugin", MyPlugin.into())?;

        let result = plugin_test.eval_with(
            "my-command",
            Value::string("test", Span::test_data()),
        )?;

        assert_eq!(result, Value::int(4, Span::test_data()));
        Ok(())
    }
}
```
```bash
cargo test
```

## Debugging Techniques

### 1. Use JsonSerializer for Debugging

```rust
fn main() {
    serve_plugin(&MyPlugin, JsonSerializer)  // Instead of MsgPackSerializer
}
```

Inspect stdin/stdout to see protocol messages.

### 2. Logging

Plugins can't use stdout/stderr (reserved for protocol), so log to a file:

```rust
use std::fs::OpenOptions;
use std::io::Write;

fn debug_log(message: &str) {
    let mut file = OpenOptions::new()
        .create(true)
        .append(true)
        .open("/tmp/myplugin.log")
        .unwrap();
    writeln!(file, "{}: {}", chrono::Local::now(), message).ok();
}

fn run(&self, ...) -> Result<Value, LabeledError> {
    debug_log(&format!("Input: {:?}", input));
    // ...
}
```

### 3. Backtrace on Panic
```bash
RUST_BACKTRACE=1 nu
```

### 4. Check Plugin Registration
```nushell
plugin list | where name == myplugin
```

### 5. Manual Protocol Testing
```bash
# Send version request
echo '{"Hello":{"protocol":"nu-plugin","version":"0.109.1"}}' | ./target/debug/nu_plugin_myplugin
```

## Common Issues

### Plugin Not Found After Building

**Problem:** `plugin add` fails or command not recognized

**Solution:**
- Ensure binary name matches `nu_plugin_*` convention
- Use absolute path with `plugin add`
- Check binary has execute permissions (Unix)

### Changes Not Reflected

**Problem:** Changes don't appear after rebuilding

**Solution:**
```nushell
plugin rm myplugin
plugin add /absolute/path/to/nu_plugin_myplugin
plugin use myplugin
```

Or restart nushell entirely.

### "Plugin panicked" Error

**Problem:** Plugin crashes during execution

**Solution:**
- Add file-based logging to see what caused panic
- Run with `RUST_BACKTRACE=1`
- Use `JsonSerializer` temporarily to see protocol messages
- Check for unwrap() calls that might panic
- Ensure all errors return LabeledError instead of panicking

### Type Mismatch Errors

**Problem:** "Expected X, got Y" errors

**Solution:**
- Check `input_output_type()` matches actual behavior
- Use pattern matching to handle multiple input types
- Return helpful error messages with proper spans

### Path Not Found Errors

**Problem:** File operations fail even with correct paths

**Solution:**
```rust
// Always use engine's current directory
let base = engine.get_current_dir()?;
let full_path = base.join(user_provided_path);
```

## Performance Testing

### Benchmark Streaming
```rust
#[bench]
fn bench_streaming(b: &mut Bencher) {
    let plugin = MyPlugin;
    let large_input = (0..10000).map(|i| Value::int(i, Span::test_data()));

    b.iter(|| {
        // Test performance with large stream
    });
}
```

### Profile with Cargo Flamegraph
```bash
cargo install flamegraph
cargo flamegraph --bin nu_plugin_myplugin
```

## Continuous Integration

Example GitHub Actions workflow:
```yaml
name: Test Plugin

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: dtolnay/rust-toolchain@stable
      - name: Run tests
        run: cargo test
      - name: Build release
        run: cargo build --release
      - name: Check binary exists
        run: test -f target/release/nu_plugin_myplugin
```

## Version Compatibility
```toml
[dependencies]
nu-plugin = "0.109.1"
nu-protocol = "0.109.1"

[dev-dependencies]
nu-plugin-test-support = "0.109.1"
```

Check version compatibility:
```bash
# See nushell version
nu --version

# Update dependencies
cargo update
```

## Reproducible Testing with Nix

The [nushellWith](https://github.com/YPares/nushellWith) flake provides reproducible Nushell environments for testing plugins.

### Quick Start

Create a `flake.nix` in your plugin directory:
```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nushellWith.url = "github:YPares/nushellWith/nu0.109";  # Match your nu version
  };

  outputs = { nixpkgs, nushellWith, ... }:
    let
      system = "x86_64-linux";  # or "aarch64-darwin", etc.
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ nushellWith.overlays.default ];
      };
      myNushell = pkgs.nushellWith {
        plugins.source = [ ./. ];  # Build your plugin from source
      };
    in {
      # Provides a 'nu' wrapper with your plugin loaded
      packages.${system}.default = myNushell;

      # Dev shell with the custom nushell available
      devShells.${system}.default = pkgs.mkShellNoCC {
        packages = [ myNushell ];
      };

      # Run tests during 'nix flake check'
      checks.${system}.default = myNushell.runNuCommand "test" {} ''
        # Your test commands here
        "hello" | my-plugin | print
      '';
    };
}
```

### Features

- **Binary caching**: Pre-built plugins via Garnix (add to `nixConfig`)
- **100+ plugins**: Most crates.io plugins available via `pkgs.nushellPlugins`
- **Isolated environments**: Test without affecting system Nushell
- **CI integration**: Run `nix flake check` in GitHub Actions
- **Standalone scripts**: Use `writeNuScriptBin` to package Nu scripts as executables
