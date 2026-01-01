# Plugin Protocol and Serialization

## Communication Model

Nushell plugins are standalone executables that communicate with the Nushell engine over stdin/stdout using a standardized serialization protocol. The plugin never directly interacts with the user's terminal—all I/O goes through the engine.

## Serialization Formats

Two serialization formats are supported:

**MsgPackSerializer** (Recommended)
- Binary format, significantly faster
- Use for production plugins
- More compact message size

**JsonSerializer**
- Text-based, human-readable
- Useful for debugging and learning
- Slower but easier to inspect

```rust
fn main() {
    serve_plugin(&MyPlugin, MsgPackSerializer)  // Production
    // serve_plugin(&MyPlugin, JsonSerializer)  // Debug
}
```

## Plugin Lifecycle

1. **Discovery** (`plugin add <path>`): Executes plugin, requests metadata, stores signatures in registry
2. **Loading** (`plugin use <name>`): Loads signatures from registry, makes commands available (plugin not yet running)
3. **Execution**: Spawns plugin process, sends serialized input/context, receives output (may persist for subsequent calls)

## Important Constraints

### Stdio Restrictions

Plugins cannot use stdin/stdout (reserved for protocol). Check before using:
```rust
use nu_plugin::EngineInterface;

fn run(&self, engine: &EngineInterface, ...) -> Result<Value, LabeledError> {
    if engine.is_using_stdio() {
        return Err(LabeledError::new("Cannot read stdin in plugin mode"));
    }
}
```

### Path Handling

Always resolve relative to engine's current directory:
```rust
let full_path = engine.get_current_dir()?.join(relative_path);
```

## Stream IDs

Streams (ListStream, ByteStream) use integer IDs for tracking. `serve_plugin()` handles this automatically.

## Error Handling

Return `LabeledError` with span information so Nushell shows where the error occurred:
```rust
Err(LabeledError::new("Error message")
    .with_label("specific issue", call.head))
```

## References
- [Plugin Protocol Reference](https://www.nushell.sh/contributor-book/plugin_protocol_reference.html)
- [PipelineData docs](https://docs.rs/nu-protocol/latest/nu_protocol/enum.PipelineData.html)
