# Evildoer: Comprehensive Architecture Specification & Implementation Guide

## Model Directive

This document serves as a comprehensive specification for GPT-5.2 (or equivalent advanced reasoning model) to understand, modify, and extend the Evildoer text editor codebase. The system employs a sophisticated macro-driven, data-oriented architecture that prioritizes orthogonality, compile-time safety, and zero-cost abstractions.

---

## CRITICAL: Implementation Expectations

<mandatory_execution_requirements>

This is NOT a documentation-only or planning-only task. When given implementation requests, you must:

1. EDIT FILES; Use the Edit tool to modify actual source files in the codebase
2. DEBUG AND FIX; Run builds, read compiler errors, iterate until code compiles
3. TEST CHANGES; Run `cargo check`, `cargo build`, `cargo test` as appropriate
4. COMPLETE FULL IMPLEMENTATION; Do not stop at partial solutions or "exercises for the reader"

**Unacceptable responses:**
- "Here's how you could implement this..."
- "You would need to add something like..."
- "The implementation would involve..."
- Providing code blocks without actually writing them to files
- Stopping after encountering the first error

**Expected workflow:**
1. Read and understand the relevant code
2. Write the implementation using Edit/Write tools
3. Run `cargo check` or `cargo build` to verify
4. If errors occur, read them, fix them, repeat
5. Run tests if applicable
6. Only report completion when code actually compiles and works

**You have full access to:**
- Read any file in the codebase
- Edit any file in the codebase
- Run any shell command (cargo, git, etc.)
- Create new files when necessary (prefer editing existing files)

**USE THESE CAPABILITIES.** Do not describe what should be done - DO IT.

</mandatory_execution_requirements>

---

## Implementation Roadmap: Concrete Tasks

This section defines the specific, measurable work items to push the orthogonal macro system further. Each phase has discrete tasks with clear completion criteria.

### Phase 1: Legacy Pattern Migration (Priority: HIGH)

**Objective:** Achieve 100% macro coverage by migrating the 2 remaining legacy patterns.

#### Task 1.1: Migrate Theme Command
- **File:** `crates/stdlib/src/commands/theme.rs`
- **Current:** Direct `#[distributed_slice(COMMANDS)]` annotation
- **Target:** Convert to `command!` macro invocation
- **Steps:**
  1. Read `crates/stdlib/src/commands/theme.rs` to understand current implementation
  2. Read `crates/manifest/src/macros.rs` to understand `command!` macro syntax
  3. Rewrite the theme command using `command!` macro
  4. Run `cargo check -p evildoer-stdlib`
  5. Run `cargo test -p evildoer-stdlib`
- **Completion Criteria:** `cargo build` succeeds, command works identically

#### Task 1.2: Migrate Editing Action
- **File:** `crates/stdlib/src/actions/editing.rs` (lines 64-75)
- **Current:** Direct `#[distributed_slice(ACTIONS)]` annotation
- **Target:** Convert to `action!` macro invocation
- **Steps:**
  1. Read the current implementation in `editing.rs`
  2. Identify which action uses direct registration
  3. Rewrite using `action!` macro with appropriate form
  4. Run `cargo check -p evildoer-stdlib`
  5. Verify keybindings still work
- **Completion Criteria:** `cargo build` succeeds, action works identically

---

### Phase 2: Text Object Macro Enhancements (Priority: HIGH)

**Objective:** Reduce boilerplate in text object definitions by 60%.

#### Task 2.1: Implement `symmetric_text_object!` Macro
- **File:** `crates/manifest/src/macros.rs`
- **Purpose:** Single macro for objects where inner == around (e.g., numbers, URLs)
- **Steps:**
  1. Read existing `text_object!` macro implementation
  2. Add new `symmetric_text_object!` macro that:
     - Takes single handler function
     - Generates both `inner:` and `around:` pointing to same fn
  3. Add to module exports
  4. Run `cargo check -p evildoer-manifest`
- **Completion Criteria:** Macro compiles, can be used in stdlib

#### Task 2.2: Implement `bracket_pair_object!` Macro
- **File:** `crates/manifest/src/macros.rs`
- **Purpose:** One-liner for bracket pair objects (parens, brackets, braces, angles)
- **Steps:**
  1. Analyze the 4 bracket pair definitions in `crates/stdlib/src/objects/`
  2. Extract common pattern into `bracket_pair_object!` macro
  3. Macro signature: `bracket_pair_object!(name, open_char, close_char, trigger, alt_triggers)`
  4. Run `cargo check -p evildoer-manifest`
- **Completion Criteria:** Macro compiles, ready for use

#### Task 2.3: Migrate Existing Text Objects to New Macros
- **Files:** `crates/stdlib/src/objects/*.rs`
- **Steps:**
  1. Identify all symmetric text objects (number, url, etc.)
  2. Migrate to `symmetric_text_object!`
  3. Migrate parentheses, brackets, braces, angles to `bracket_pair_object!`
  4. Run full test suite: `cargo test -p evildoer-stdlib`
- **Completion Criteria:** All tests pass, less total code

---

### Phase 3: Hook System Unification (Priority: MEDIUM-HIGH)

**Objective:** Merge `HookDef` and `MutableHookDef` into unified system.

#### Task 3.1: Analyze Current Hook Duplication
- **Files:** `crates/manifest/src/hooks.rs`
- **Steps:**
  1. Document all fields in `HookDef` vs `MutableHookDef`
  2. Document all functions in `emit_hook` vs `emit_mutable_hook`
  3. Identify exact differences and why they exist
  4. Design unified `HookDef` that supports both patterns
- **Completion Criteria:** Design document with concrete struct definitions

#### Task 3.2: Implement Unified Hook Infrastructure
- **File:** `crates/manifest/src/hooks.rs`
- **Steps:**
  1. Add `mutability: HookMutability` field to `HookDef`
  2. Create `enum HookMutability { Immutable, Mutable }`
  3. Update `emit_hook` to check mutability and dispatch appropriately
  4. Deprecate `MutableHookDef` and `MUTABLE_HOOKS` slice
  5. Run `cargo check -p evildoer-manifest`
- **Completion Criteria:** Single hook system compiles

#### Task 3.3: Update `hook!` Macro for Mutability
- **File:** `crates/manifest/src/macros.rs`
- **Steps:**
  1. Add optional `mutable` keyword to `hook!` macro syntax
  2. When `mutable` present, set `HookMutability::Mutable`
  3. Update handler signature inference based on mutability
  4. Run `cargo check -p evildoer-manifest`
- **Completion Criteria:** `hook!(name, Event, priority, "desc", mutable |ctx| { ... })` works

#### Task 3.4: Migrate Existing Hooks
- **Files:** All files using `MUTABLE_HOOKS`
- **Steps:**
  1. Find all `#[distributed_slice(MUTABLE_HOOKS)]` usages
  2. Convert to `hook!(..., mutable |ctx| { ... })`
  3. Remove old `MUTABLE_HOOKS` slice after migration
  4. Run full test suite
- **Completion Criteria:** No more `MUTABLE_HOOKS` references

---

### Phase 4: Async Hook Bridging (Priority: MEDIUM)

**Objective:** Eliminate manual `to_owned()` + closure capture boilerplate.

#### Task 4.1: Implement `async_hook!` Macro
- **File:** `crates/manifest/src/macros.rs`
- **Steps:**
  1. Design macro that accepts `async |param1, param2| { ... }` syntax
  2. Auto-generate `to_owned()` conversion for borrowed parameters
  3. Auto-wrap in `HookAction::Async(Box::pin(...))`
  4. Handle owned parameter types (PathBuf, String, etc.)
  5. Run `cargo check -p evildoer-manifest`
- **Completion Criteria:** Macro compiles and generates correct code

#### Task 4.2: Add Parameter Extraction to Hook Macros
- **File:** `crates/manifest/src/macros.rs`
- **Steps:**
  1. Parse parameter names and types from closure signature
  2. Generate pattern matching on `HookEventData` to extract fields
  3. Pass extracted fields directly to user closure
  4. Example: `|path: &Path, text: RopeSlice|` extracts from `BufferOpen`
- **Completion Criteria:** No more manual `if let HookEventData::...` in hooks

#### Task 4.3: Migrate LSP Hooks to `async_hook!`
- **Files:** `crates/extensions/extensions/lsp/hooks.rs`
- **Steps:**
  1. Find all async hooks with manual `to_owned()`
  2. Rewrite using `async_hook!` macro
  3. Verify LSP functionality still works
  4. Run `cargo test`
- **Completion Criteria:** Cleaner hook code, same functionality

---

### Phase 5: Extension Declaration Macro (Priority: MEDIUM)

**Objective:** Single `#[extension]` attribute generates all registration boilerplate.

#### Task 5.1: Design Extension Attribute Macro
- **File:** `crates/macro/src/extension.rs` (new file)
- **Steps:**
  1. Define `#[extension(id = "...", priority = N)]` attribute
  2. Parse struct definition to find state type
  3. Look for `#[init]`, `#[hook]`, `#[render]`, `#[command]` methods
  4. Generate `ExtensionInitDef`, hook registrations, etc.
- **Completion Criteria:** Design documented with example expansions

#### Task 5.2: Implement `#[extension]` Proc Macro
- **File:** `crates/macro/src/extension.rs`
- **Steps:**
  1. Create new proc macro crate or add to existing `evildoer-macro`
  2. Implement struct parsing with syn
  3. Implement method attribute parsing
  4. Generate distributed slice registrations
  5. Run `cargo check -p evildoer-macro`
- **Completion Criteria:** Proc macro compiles

#### Task 5.3: Migrate Zenmode Extension
- **Files:** `crates/extensions/extensions/zenmode/`
- **Steps:**
  1. Rewrite `ZenmodeState` using `#[extension]` attribute
  2. Convert init function to `#[init]` method
  3. Convert render function to `#[render]` method
  4. Convert command to `#[command]` method
  5. Verify functionality preserved
- **Completion Criteria:** Less code, same functionality

---

### Phase 6: Event Schema Generation (Priority: LOW-MEDIUM)

**Objective:** Single source of truth for event definitions.

#### Task 6.1: Design `events!` Macro
- **File:** `crates/manifest/src/macros.rs`
- **Steps:**
  1. Define syntax for event schema declaration
  2. Plan what gets generated:
     - `HookEvent` enum (simple variants)
     - `HookEventData<'a>` enum (borrowed data)
     - `OwnedHookContext` enum (owned data)
     - Conversion methods
  3. Document the macro expansion
- **Completion Criteria:** Clear design document

#### Task 6.2: Implement `events!` Macro
- **File:** `crates/manifest/src/macros.rs` or new proc macro
- **Steps:**
  1. If declarative macro suffices, implement in macros.rs
  2. If proc macro needed, add to evildoer-macro
  3. Generate all three enums from single definition
  4. Generate `to_owned()` and `From` implementations
  5. Run `cargo check -p evildoer-manifest`
- **Completion Criteria:** Macro generates correct code

#### Task 6.3: Migrate Hook System to Generated Events
- **File:** `crates/manifest/src/hooks.rs`
- **Steps:**
  1. Replace hand-written `HookEvent`, `HookEventData`, `OwnedHookContext`
  2. Use `events!` macro invocation instead
  3. Verify all existing code still compiles
  4. Run full test suite
- **Completion Criteria:** Single source of truth, all tests pass

---

### Phase 7: Result Handler Enhancements (Priority: LOW)

**Objective:** Add metadata and validation to result handlers.

#### Task 7.1: Add Handler Metadata Fields
- **File:** `crates/manifest/src/editor_ctx/handlers.rs`
- **Steps:**
  1. Add `priority: i16` field to `ResultHandler`
  2. Add `required_caps: &'static [Capability]` field
  3. Update `result_handler!` macro to accept these fields
  4. Update dispatch logic to sort by priority
  5. Run `cargo check -p evildoer-manifest`
- **Completion Criteria:** Handlers have metadata, dispatch respects priority

#### Task 7.2: Implement Handler Coverage Checking
- **File:** `crates/macro/src/dispatch.rs`
- **Steps:**
  1. Add `#[handler_coverage = "error"|"warn"|"ignore"]` attribute
  2. In `#[derive(DispatchResult)]`, collect all variants
  3. At compile time or init time, verify handlers exist for all variants
  4. Emit error/warning based on coverage setting
- **Completion Criteria:** Missing handlers detected at compile/init time

---

### Phase 8: Configuration Extraction (Priority: LOW)

**Objective:** Move hardcoded values to declarative configuration.

#### Task 8.1: Extract Terminal Configuration
- **Files:** `crates/term/src/terminal.rs`, new `crates/manifest/src/terminal_config.rs`
- **Steps:**
  1. Create `TerminalConfig` struct with capability flags
  2. Move hardcoded escape sequences to config-driven generation
  3. Allow runtime detection of terminal capabilities
  4. Run `cargo check -p evildoer-term`
- **Completion Criteria:** Terminal setup is configurable

#### Task 8.2: Extract UI Layout Configuration
- **Files:** `crates/api/src/render/`, new config module
- **Steps:**
  1. Create `UiLayout` struct with statusline height, dock layer, etc.
  2. Replace hardcoded `Constraint::Length(1)` with config lookup
  3. Add `option!` entries for user-configurable values
  4. Run `cargo check -p evildoer-api`
- **Completion Criteria:** Layout dimensions are configurable

#### Task 8.3: Extract Render Timing Configuration
- **Files:** `crates/term/src/app.rs`
- **Steps:**
  1. Create `RenderTiming` struct with poll intervals per mode
  2. Replace hardcoded 16ms/50ms with config lookup
  3. Add `option!` entries for user tuning
  4. Run `cargo check -p evildoer-term`
- **Completion Criteria:** Frame timing is configurable

---

### Verification Checklist

After completing each phase, verify:

- [ ] `cargo check` passes for all affected crates
- [ ] `cargo build` succeeds
- [ ] `cargo test` passes (no regressions)
- [ ] `cargo clippy` has no new warnings
- [ ] Code follows existing patterns and style
- [ ] No new direct `#[distributed_slice]` usage (use macros)
- [ ] Documentation updated if public API changed

### Success Metrics

| Phase | Metric | Target |
|-------|--------|--------|
| 1 | Legacy patterns remaining | 0 |
| 2 | Text object LOC reduction | 40%+ |
| 3 | Hook system code duplication | 0% |
| 4 | Manual `to_owned()` in hooks | 0 |
| 5 | Extension boilerplate LOC | -60% |
| 6 | Event definition duplication | 0 |
| 7 | Unhandled ActionResult variants | 0 |
| 8 | Hardcoded magic numbers | -80% |

---

## 1. Executive Summary

Evildoer is a Kakoune-inspired modal text editor written in Rust. Its defining architectural characteristic is a **data-driven macro pipeline** that replaces traditional imperative code patterns with declarative registrations compiled into static dispatch tables.

### Core Philosophy

```
DATA DESCRIBES → MACROS DERIVE → USERS CONFIGURE
```

- **All behavior is specified as data** (structs, enums, KDL configuration)
- **Proc macros generate glue code** (handlers, dispatch, validation)
- **Zero coupling** between components (everything via `linkme` distributed slices)
- **Compile-time safety** for all registrations
- **Runtime configurability** only where it genuinely adds value

### Key Statistics

| Category | Total Items | Macro-Registered | Legacy Pattern |
|----------|-------------|------------------|----------------|
| Actions | 86 | 85 | 1 |
| Commands | 13 | 12 | 1 |
| Motions | 19 | 19 | 0 |
| Hooks | 2+ | 2+ | 0 |
| Text Objects | 13 | 13 | 0 |
| Options | 24 | 24 | 0 |
| Statusline Segments | 6 | 6 | 0 |
| Result Handlers | 8+ | 8+ | 0 |
| **TOTAL** | **171+** | **169+** | **2** |

---

## 2. Behavioral Constraints for Implementation

<verbosity_and_scope_constraints>

When implementing changes to Evildoer:

- Produce MINIMAL code changes that satisfy the requirement.
- PREFER editing existing files over creating new ones.
- ALWAYS use the macro system (`action!`, `command!`, `hook!`, etc.) for new registrations.
- NEVER use direct `#[distributed_slice]` annotations when a macro exists.
- NO extra features, no added components, no architectural embellishments.
- If any instruction is ambiguous, choose the simplest valid interpretation.
- Follow existing code patterns exactly - match indentation, naming conventions, and style.

</verbosity_and_scope_constraints>

<design_system_enforcement>

- Explore the existing macro system deeply before proposing changes.
- Implement EXACTLY and ONLY what is requested.
- Style aligned to existing patterns in the codebase.
- Do NOT invent new macro patterns when existing ones suffice.
- Do NOT add capabilities, traits, or abstractions unless explicitly required.
- When extending macros, maintain backward compatibility with existing invocations.

</design_system_enforcement>

<long_context_handling>

- For modifications spanning multiple files:
  - First, produce a short internal outline of which files need changes.
  - Re-state the user's constraints explicitly before implementing.
  - Anchor changes to specific locations ("In `crates/stdlib/src/actions/editing.rs`...").
- If the change depends on fine details (macro syntax, trait bounds, slice names), quote or paraphrase them.

</long_context_handling>

<ambiguity_handling>

When encountering unclear requirements:

- ASK for clarification before implementing if the ambiguity could lead to architectural decisions.
- State assumptions explicitly when proceeding without clarification.
- NEVER invent requirements - implement only what is specified.
- If a feature could be implemented multiple ways, choose the one that:
  1. Uses existing macro infrastructure
  2. Requires the least new code
  3. Follows established patterns in the codebase

</ambiguity_handling>

---

## 3. Crate Architecture

### 3.1 Crate Dependency Graph

```
evildoer-term (binary)
    ├── evildoer-api (editor core)
    │   ├── evildoer-manifest (registry definitions)
    │   │   ├── evildoer-base (primitives)
    │   │   └── evildoer-macro (proc macros)
    │   ├── evildoer-stdlib (implementations)
    │   ├── evildoer-language (syntax/treesitter)
    │   └── evildoer-config (KDL parsing)
    ├── evildoer-extensions (host extensions)
    ├── evildoer-tui (terminal UI)
    ├── evildoer-input (key handling)
    └── evildoer-keymap (key parsing/matching)
```

### 3.2 Crate Responsibilities

| Crate | Purpose | Contains |
|-------|---------|----------|
| `evildoer-base` | Primitives | `Range`, `Selection`, `CharIdx`, transactions |
| `evildoer-manifest` | Registry contracts | Distributed slices, trait definitions, declarative macros |
| `evildoer-macro` | Proc macros | `parse_keybindings!`, `DispatchResult`, `buffer_ops_handler!` |
| `evildoer-stdlib` | Implementations | Actions, commands, motions, hooks, options, text objects |
| `evildoer-api` | Editor core | `Editor` struct, buffer management, rendering |
| `evildoer-extensions` | Host extensions | LSP, ACP (AI), panels with stateful services |
| `evildoer-config` | Configuration | KDL theme/config parsing |
| `evildoer-language` | Language support | Tree-sitter integration, syntax highlighting |
| `evildoer-input` | Input handling | `InputHandler`, mode management, key accumulation |
| `evildoer-keymap` | Key infrastructure | Key parsing, trie-based matching |
| `evildoer-tui` | Terminal UI | Ratatui integration, rendering pipeline |
| `evildoer-term` | Binary entry | Main loop, terminal setup |

### 3.3 The Manifest/Stdlib Split

**Critical Design Pattern**: Definitions live in `evildoer-manifest`, implementations live in `evildoer-stdlib`.

```rust
// In evildoer-manifest/src/lib.rs - DEFINITION
#[distributed_slice]
pub static ACTIONS: [ActionDef];

pub struct ActionDef {
    pub id: &'static str,
    pub name: &'static str,
    pub handler: fn(&ActionContext) -> ActionResult,
    // ...
}
```

```rust
// In evildoer-stdlib/src/actions/motions.rs - IMPLEMENTATION
action!(move_left, {
    description: "Move cursor left",
    bindings: r#"normal "h" "left"
insert "left""#,
}, |ctx| cursor_motion(ctx, "move_left"));
```

This separation enables:
- Clean dependency graph (no cycles)
- Extensions can depend on manifest without stdlib
- Compile-time type safety across crate boundaries

---

## 4. The Distributed Slice Pattern

### 4.1 Core Mechanism

The `linkme` crate enables compile-time registration across crate boundaries:

```rust
// Declaration (in manifest)
#[distributed_slice]
pub static ACTIONS: [ActionDef];

// Registration (in any crate)
#[distributed_slice(ACTIONS)]
static MY_ACTION: ActionDef = ActionDef { ... };
```

At link time, all registrations are collected into a single contiguous slice. This provides:
- **Zero runtime cost**: Data is in the binary, no allocation
- **No explicit registration**: Items appear automatically
- **Cross-crate composition**: Any crate can contribute

### 4.2 Current Distributed Slices

| Slice | Type | Location | Purpose |
|-------|------|----------|---------|
| `ACTIONS` | `[ActionDef]` | manifest | All editor actions |
| `COMMANDS` | `[CommandDef]` | manifest | Ex-mode commands |
| `MOTIONS` | `[MotionDef]` | manifest | Cursor movement primitives |
| `TEXT_OBJECTS` | `[TextObjectDef]` | manifest | Text object selection |
| `KEYBINDINGS` | `[KeyBindingDef]` | manifest | Key-to-action mappings |
| `HOOKS` | `[HookDef]` | manifest | Lifecycle event handlers |
| `MUTABLE_HOOKS` | `[MutableHookDef]` | manifest | State-modifying hooks |
| `OPTIONS` | `[OptionDef]` | manifest | Configuration options |
| `STATUSLINE_SEGMENTS` | `[StatuslineSegmentDef]` | manifest | Status bar segments |
| `NOTIFICATION_TYPES` | `[NotificationTypeDef]` | manifest | Notification styles |
| `THEMES` | `[Theme]` | manifest | Color themes |
| `PANELS` | `[PanelDef]` | manifest | Panel metadata |
| `PANEL_FACTORIES` | `[PanelFactoryDef]` | manifest | Panel creation |
| `EXTENSIONS` | `[ExtensionInitDef]` | api | Extension initialization |
| `TICK_EXTENSIONS` | `[ExtensionTickDef]` | api | Per-tick extension updates |
| `RENDER_EXTENSIONS` | `[ExtensionRenderDef]` | api | Pre-render extension updates |
| `RESULT_*_HANDLERS` | `[ResultHandler]` | manifest | Per-variant result dispatch |

---

## 5. Macro System Reference

### 5.1 The `action!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register actions with optional keybindings and handlers.

**Forms**:

```rust
// Form 1: Simple closure, no keybindings
action!(name, { description: "..." }, |ctx| { ... });

// Form 2: With keybindings (KDL format)
action!(name, {
    description: "...",
    bindings: r#"normal "h" "left"
insert "left""#,
}, |ctx| { ... });

// Form 3: Handler function reference
action!(name, { description: "..." }, handler: my_handler_fn);

// Form 4: Buffer-ops form (generates action + result handler)
action!(split_horizontal, {
    description: "Split horizontally",
    bindings: r#"window "s""#,
    result: SplitHorizontal,
}, |ops| ops.split_horizontal());
```

**Generated Output**:
1. `ActionDef` entry in `ACTIONS` slice
2. `KeyBindingDef` entries in `KEYBINDINGS` slice (if bindings specified)
3. Handler function (if closure provided)
4. `ResultHandler` entry (if `result:` form used)

**Optional Fields**:
- `aliases: &["alias1", "alias2"]` - Alternative names
- `priority: i16` - Conflict resolution (higher wins)
- `caps: &[Capability::Edit, ...]` - Required capabilities
- `flags: u32` - Behavior flags

### 5.2 The `command!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register ex-mode commands (`:write`, `:quit`, etc.).

```rust
command!(write, {
    aliases: &["w"],
    description: "Write buffer to file",
    caps: &[Capability::FileOps],
}, handler: write_handler);

// Handler signature
fn write_handler<'a>(ctx: &'a mut CommandContext<'a>)
    -> LocalBoxFuture<'a, Result<CommandOutcome, CommandError>>
{
    Box::pin(async move {
        // Implementation
        Ok(CommandOutcome::Ok)
    })
}
```

### 5.3 The `motion!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register cursor movement primitives.

```rust
motion!(move_left, {
    description: "Move cursor left",
}, |text, range, count, extend| {
    // text: RopeSlice - document content
    // range: Range - current selection range
    // count: usize - repetition count
    // extend: bool - extend selection?

    let new_head = range.head.saturating_sub(count);
    if extend {
        Range::new(range.anchor, new_head)
    } else {
        Range::point(new_head)
    }
});
```

### 5.4 The `text_object!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register text object selection (inner word, around quotes, etc.).

```rust
text_object!(word, {
    trigger: 'w',
    alt_triggers: &['W'],
    description: "Word text object",
}, {
    inner: word_inner,
    around: word_around,
});

// Handler signatures
fn word_inner(text: RopeSlice, pos: usize) -> Option<Range> { ... }
fn word_around(text: RopeSlice, pos: usize) -> Option<Range> { ... }
```

### 5.5 The `hook!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register lifecycle event handlers.

```rust
hook!(log_buffer_open, BufferOpen, 1000, "Log buffer opens", |ctx| {
    if let HookEventData::BufferOpen { path, file_type, .. } = &ctx.data {
        tracing::info!(path = %path.display(), "Opened buffer");
    }
});
```

**Parameters**:
1. `name` - Hook identifier
2. `event` - `HookEvent` variant to subscribe to
3. `priority` - Execution order (lower runs first)
4. `description` - Human-readable description
5. `handler` - Closure receiving `&HookContext`

**Available Events**:
- `EditorStart`, `EditorQuit`, `EditorTick`
- `BufferOpen`, `BufferWritePre`, `BufferWrite`, `BufferClose`, `BufferChange`
- `ModeChange`, `CursorMove`, `SelectionChange`
- `WindowResize`, `FocusGained`, `FocusLost`

### 5.6 The `option!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register configuration options.

```rust
option!(scroll_margin, Int, 3, Global, "Lines of context around cursor");
option!(line_numbers, Bool, true, Buffer, "Show line numbers");
option!(tab_width, Int, 4, Buffer, "Tab display width");
```

**Parameters**:
1. `name` - Option identifier
2. `type` - `Bool`, `Int`, or `String`
3. `default` - Default value
4. `scope` - `Global` or `Buffer`
5. `description` - Human-readable description

### 5.7 The `statusline_segment!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register modular status bar segments.

```rust
statusline_segment!(
    SEG_MODE,           // Static name
    "mode",             // ID
    SegmentPosition::Left,
    0,                  // Priority (lower = renders first)
    true,               // Default enabled
    |ctx| {
        Some(RenderedSegment {
            text: format!(" {} ", ctx.mode_name),
            style: SegmentStyle::Mode,
        })
    }
);
```

### 5.8 The `panel!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register toggleable split views (terminals, file trees, etc.).

```rust
panel!(terminal, {
    description: "Embedded terminal emulator",
    mode_name: "TERMINAL",
    layer: 1,
    sticky: true,
    factory: || Box::new(TerminalBuffer::new()),
});
```

### 5.9 The `result_handler!` Macro

**Location**: `crates/manifest/src/macros.rs`

**Purpose**: Register handlers for `ActionResult` variants.

```rust
result_handler!(
    RESULT_MOTION_HANDLERS,  // Slice name
    HANDLE_MOTION,           // Static name
    "motion",                // Debug name
    |result, ctx, extend| {
        if let ActionResult::Motion(selection) = result {
            ctx.set_selection(selection.clone());
            HandleOutcome::Handled
        } else {
            HandleOutcome::NotHandled
        }
    }
);
```

---

## 6. The Action Execution Pipeline

### 6.1 Complete Flow Diagram

```
User Input (Key Event)
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│ INPUT HANDLER (crates/input/src/handler.rs)                 │
│                                                             │
│ 1. Mode-specific handling (Normal/Insert/Window/Pending)    │
│ 2. Count accumulation (numeric prefix)                      │
│ 3. Key sequence accumulation (multi-key bindings)           │
│ 4. Keymap lookup via KeymapRegistry                         │
│                                                             │
│ Returns: KeyResult::ActionById { id, count, extend, reg }   │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│ ACTION RESOLUTION (crates/manifest/src/index/)              │
│                                                             │
│ 1. find_action_by_id(ActionId) → &'static ActionDef        │
│ 2. Check required_caps against EditorCapabilities           │
│                                                             │
│ ActionDef contains: id, name, handler, required_caps, etc.  │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│ ACTION EXECUTION (crates/api/src/editor/actions_exec.rs)    │
│                                                             │
│ 1. Build ActionContext (read-only buffer state snapshot)    │
│    - text: RopeSlice                                        │
│    - cursor: CharIdx                                        │
│    - selection: &Selection                                  │
│    - count, extend, register, args                          │
│                                                             │
│ 2. Call action.handler(&ctx) → ActionResult                 │
│    (Pure function: no side effects)                         │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│ RESULT DISPATCH (generated by #[derive(DispatchResult)])    │
│                                                             │
│ 1. Match on ActionResult variant                            │
│ 2. Route to RESULT_*_HANDLERS distributed slice             │
│ 3. Execute handlers in registration order                   │
│ 4. First Handled/Quit wins; NotHandled continues            │
│                                                             │
│ Handlers mutate EditorContext (cursor, selection, mode)     │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│ STATE UPDATE                                                │
│                                                             │
│ - Selection updated                                         │
│ - Mode changed (if applicable)                              │
│ - needs_redraw = true                                       │
│ - Hooks emitted (ModeChange, CursorMove, etc.)              │
└─────────────────────────────────────────────────────────────┘
    │
    ▼
┌─────────────────────────────────────────────────────────────┐
│ RENDER (next frame)                                         │
│                                                             │
│ 1. Run RENDER_EXTENSIONS                                    │
│ 2. Compute layout                                           │
│ 3. Render buffers with updated state                        │
│ 4. Render status line                                       │
│ 5. Render notifications                                     │
│ 6. Diff and flush to terminal                               │
└─────────────────────────────────────────────────────────────┘
```

### 6.2 ActionResult Enum

**Location**: `crates/manifest/src/actions.rs`

```rust
#[derive(Debug, Clone, DispatchResult)]
pub enum ActionResult {
    // Terminal-safe variants (can execute without buffer context)
    #[terminal_safe]
    Ok,
    #[terminal_safe]
    #[handler(Quit)]
    Quit,
    #[terminal_safe]
    #[handler(Quit)]
    ForceQuit,
    #[terminal_safe]
    Error(String),
    #[terminal_safe]
    ForceRedraw,
    #[terminal_safe]
    SplitHorizontal,
    #[terminal_safe]
    SplitVertical,
    #[terminal_safe]
    TogglePanel(&'static str),
    #[terminal_safe]
    BufferNext,
    #[terminal_safe]
    BufferPrev,
    #[terminal_safe]
    CloseSplit,
    #[terminal_safe]
    CloseOtherBuffers,
    #[terminal_safe]
    FocusLeft,
    #[terminal_safe]
    FocusRight,
    #[terminal_safe]
    FocusUp,
    #[terminal_safe]
    FocusDown,

    // Buffer-context variants
    ModeChange(ActionMode),
    CursorMove(CharIdx),
    Motion(Selection),
    InsertWithMotion(Selection),
    Edit(EditAction),
    Pending(PendingAction),
    SearchNext { add_selection: bool },
    SearchPrev { add_selection: bool },
    #[handler(UseSelectionSearch)]
    UseSelectionAsSearch,
}
```

**The `#[derive(DispatchResult)]` macro generates**:
1. `RESULT_*_HANDLERS` distributed slices for each variant
2. `dispatch_result()` function with exhaustive match
3. `is_terminal_safe()` method from `#[terminal_safe]` attributes

---

## 7. Keybinding System

### 7.1 KDL Binding Format

Keybindings are specified in KDL format within the `bindings:` field:

```kdl
normal "h" "left" "ctrl-h"
insert "left"
window "s"
```

**Mode names**: `normal`, `insert`, `window`, `match`, `space`

**Key format**:
- Single character: `"h"`, `"x"`, `"1"`
- Named keys: `"left"`, `"right"`, `"up"`, `"down"`, `"enter"`, `"esc"`, `"tab"`, `"space"`, `"backspace"`, `"delete"`, `"home"`, `"end"`, `"pageup"`, `"pagedown"`
- Function keys: `"f1"` through `"f12"`
- Modifiers: `"ctrl-x"`, `"alt-x"`, `"shift-x"`, `"ctrl-alt-x"`
- Multi-key sequences: `"g g"` (space-separated)
- Character groups: `"@digit"`, `"@lower"`, `"@upper"`, `"@alpha"`, `"@alnum"`, `"@any"`

### 7.2 KeymapRegistry

**Location**: `crates/manifest/src/keymap_registry.rs`

The registry builds a trie-based matcher from all `KeyBindingDef` entries:

```rust
pub struct KeymapRegistry {
    matchers: HashMap<BindingMode, Matcher<BindingEntry>>,
}

pub struct BindingEntry {
    pub action_id: ActionId,
    pub action_name: &'static str,
    pub keys: Vec<Node>,
}

pub enum LookupResult<'a> {
    Match(&'a BindingEntry),           // Complete match
    Pending { sticky: Option<&'a BindingEntry> },  // More keys needed
    None,                               // No match
}
```

### 7.3 Lookup Priority

1. **Exact match** (most specific) - `"h"` matches before `"@lower"`
2. **Group match with same modifiers** - `"@digit"` matches any digit
3. **@any match** (most general) - wildcard fallback

---

## 8. Editor Context and Capabilities

### 8.1 EditorCapabilities Trait

**Location**: `crates/manifest/src/editor_ctx/mod.rs`

```rust
pub trait EditorCapabilities:
    CursorAccess + SelectionAccess + ModeAccess + MessageAccess
{
    fn search(&mut self) -> Option<&mut dyn SearchAccess> { None }
    fn undo(&mut self) -> Option<&mut dyn UndoAccess> { None }
    fn edit(&mut self) -> Option<&mut dyn EditAccess> { None }
    fn buffer_ops(&mut self) -> Option<&mut dyn BufferOpsAccess> { None }
    fn file_ops(&mut self) -> Option<&mut dyn FileOpsAccess> { None }
}
```

**Required traits** (always available):
- `CursorAccess` - `cursor()`, `set_cursor()`
- `SelectionAccess` - `selection()`, `selection_mut()`, `set_selection()`
- `ModeAccess` - `mode()`, `set_mode()`
- `MessageAccess` - `notify()`, `clear_message()`

**Optional traits** (may return `None`):
- `SearchAccess` - Pattern search with multi-selection
- `UndoAccess` - Undo/redo history
- `EditAccess` - Text modification
- `BufferOpsAccess` - Split/buffer management
- `FileOpsAccess` - File I/O

### 8.2 Capability Enum

```rust
pub enum Capability {
    Text,
    Cursor,
    Selection,
    Mode,
    Messaging,
    Edit,
    Search,
    Undo,
    BufferOps,
    FileOps,
}
```

Actions declare required capabilities; checked before execution:

```rust
action!(save, {
    description: "Save file",
    caps: &[Capability::FileOps],
}, |ctx| { ... });
```

---

## 9. Hook System

### 9.1 HookEvent Variants

```rust
pub enum HookEvent {
    EditorStart,
    EditorQuit,
    EditorTick,
    BufferOpen,
    BufferWritePre,
    BufferWrite,
    BufferClose,
    BufferChange,
    ModeChange,
    CursorMove,
    SelectionChange,
    WindowResize,
    FocusGained,
    FocusLost,
}
```

### 9.2 HookContext and Data

```rust
pub struct HookContext<'a> {
    pub data: HookEventData<'a>,
    extensions: Option<&'a dyn Any>,
}

pub enum HookEventData<'a> {
    BufferOpen { path: &'a Path, text: RopeSlice<'a>, file_type: Option<&'a str> },
    BufferChange { path: &'a Path, text: RopeSlice<'a>, file_type: Option<&'a str>, version: u64 },
    ModeChange { old_mode: Mode, new_mode: Mode },
    CursorMove { line: usize, col: usize },
    // ... other variants
}
```

### 9.3 HookAction Returns

```rust
pub enum HookAction {
    Done(HookResult),
    Async(BoxFuture<HookResult>),
}

pub enum HookResult {
    Continue,
    Cancel,  // Stops hook chain (e.g., prevent BufferWrite)
}
```

### 9.4 Hook Emission

```rust
// Async emission (in async context)
emit_hook(&ctx).await;

// Sync emission with scheduler (defers async hooks)
emit_hook_sync_with(&ctx, &mut scheduler);

// Sync emission (warns on async hooks)
emit_hook_sync(&ctx);
```

---

## 10. Extension System

### 10.1 Extension Lifecycle

Extensions register via three distributed slices:

```rust
// Initialization (runs once at Editor::from_content())
#[distributed_slice(EXTENSIONS)]
static LSP_INIT: ExtensionInitDef = ExtensionInitDef {
    id: "lsp",
    priority: 50,
    init: init_lsp,
};

// Per-tick update (runs every event loop iteration)
#[distributed_slice(TICK_EXTENSIONS)]
static LSP_TICK: ExtensionTickDef = ExtensionTickDef {
    priority: 50,
    tick: tick_lsp,
};

// Pre-render update (runs before each frame)
#[distributed_slice(RENDER_EXTENSIONS)]
static ZENMODE_RENDER: ExtensionRenderDef = ExtensionRenderDef {
    priority: 100,
    update: update_zenmode,
};
```

### 10.2 ExtensionMap (Type-Safe State)

```rust
pub struct ExtensionMap {
    inner: HashMap<TypeId, Box<dyn Any + Send + Sync>>,
}

impl ExtensionMap {
    pub fn insert<T: Any + Send + Sync>(&mut self, val: T);
    pub fn get<T: Any + Send + Sync>(&self) -> Option<&T>;
    pub fn get_mut<T: Any + Send + Sync>(&mut self) -> Option<&mut T>;
}

// Usage in extension
fn init_lsp(map: &mut ExtensionMap) {
    map.insert(Arc::new(LspManager::new()));
}

// Retrieval
let lsp = editor.extensions.get::<Arc<LspManager>>();
```

### 10.3 Auto-Discovery

Extensions in `crates/extensions/extensions/` are auto-discovered by `build.rs`:

```
crates/extensions/
├── build.rs              # Scans extensions/ directory
├── src/lib.rs            # include!(concat!(env!("OUT_DIR"), "/extensions.rs"))
└── extensions/
    ├── lsp/
    │   ├── mod.rs        # LspManager, init function
    │   └── hooks.rs      # Hook handlers
    └── zenmode/
        ├── mod.rs        # State, render logic
        └── commands.rs   # :zen command
```

---

## 11. Theme System

### 11.1 Theme Structure

```rust
pub struct Theme {
    pub id: &'static str,
    pub name: &'static str,
    pub aliases: &'static [&'static str],
    pub variant: ThemeVariant,  // Dark or Light
    pub colors: ThemeColors,
    pub priority: i16,
    pub source: RegistrySource,
}

pub struct ThemeColors {
    pub ui: UiColors,           // Editor chrome
    pub status: StatusColors,   // Mode-specific status bar
    pub popup: PopupColors,     // Completion/menu
    pub notification: NotificationColors,
    pub syntax: SyntaxStyles,   // 74 tree-sitter scope styles
}
```

### 11.2 KDL Theme Format

```kdl
name "gruvbox"
variant "dark"

palette {
    primary "#d4af37"
    accent "#ff6b6b"
}

ui {
    bg "#1e1e1e"
    fg "#e0e0e0"
    cursor-bg "#ffffff"
    cursor-fg "#000000"
    selection-bg "#0066ff"
}

status {
    normal-bg "#0066ff"
    normal-fg "#ffffff"
    insert-bg "#00cc00"
    insert-fg "#000000"
}

syntax {
    comment fg="$accent" mod="italic"
    keyword fg="#ff7700"
    keyword {
        control fg="#ff5500"
    }
}
```

### 11.3 Runtime Theme Registration

```rust
// Themes loaded from ~/.config/evildoer/themes/
// Leaked to obtain 'static lifetime
pub fn register_runtime_themes(themes: Vec<OwnedTheme>) {
    let leaked: Vec<&'static Theme> = themes
        .into_iter()
        .map(OwnedTheme::leak)
        .collect();
    RUNTIME_THEMES.set(leaked);
}
```

---

## 12. Panel System

### 12.1 SplitBuffer Trait

```rust
pub trait SplitBuffer: Send {
    fn id(&self) -> &str;
    fn on_open(&mut self) {}
    fn on_close(&mut self) {}
    fn on_focus_changed(&mut self, focused: bool) {}
    fn resize(&mut self, size: SplitSize);
    fn tick(&mut self, delta: Duration) -> SplitEventResult;
    fn handle_key(&mut self, key: SplitKey) -> SplitEventResult;
    fn handle_mouse(&mut self, mouse: SplitMouse) -> SplitEventResult;
    fn handle_paste(&mut self, text: &str) -> SplitEventResult;
    fn size(&self) -> SplitSize;
    fn cursor(&self) -> Option<SplitCursor>;
    fn for_each_cell(&self, f: &mut dyn FnMut(u16, u16, &SplitCell));
}
```

### 12.2 Panel Registration

```rust
panel!(debug, {
    description: "Debug log viewer",
    mode_name: "DEBUG",
    layer: 2,
    singleton: true,
    sticky: true,
    factory: || Box::new(DebugPanel::new()),
});
```

**Fields**:
- `description` - Human-readable description
- `mode_name` - Status bar text when focused
- `layer` - Docking layer (higher overlays lower)
- `singleton` - Only one instance allowed (default: true)
- `sticky` - Resist losing focus on hover (default: false)
- `factory` - Creation function (optional)

---

## 13. Index and Lookup System

### 13.1 Lazy Registry Initialization

```rust
static REGISTRY: OnceLock<ExtensionRegistry> = OnceLock::new();

pub fn get_registry() -> &'static ExtensionRegistry {
    REGISTRY.get_or_init(builders::build_registry)
}
```

### 13.2 Registry Structure

```rust
pub struct ExtensionRegistry {
    pub commands: RegistryIndex<CommandDef>,
    pub actions: ActionRegistryIndex,
    pub motions: RegistryIndex<MotionDef>,
    pub text_objects: RegistryIndex<TextObjectDef>,
}

pub struct ActionRegistryIndex {
    pub base: RegistryIndex<ActionDef>,
    pub by_action_id: Vec<&'static ActionDef>,
    pub name_to_id: HashMap<&'static str, ActionId>,
    pub alias_to_id: HashMap<&'static str, ActionId>,
}
```

### 13.3 Lookup Functions

```rust
// String-based lookup (for config/help)
pub fn find_action(name: &str) -> Option<&'static ActionDef>;
pub fn find_command(name: &str) -> Option<&'static CommandDef>;
pub fn find_motion(name: &str) -> Option<&'static MotionDef>;

// ID-based lookup (hot path)
pub fn find_action_by_id(id: ActionId) -> Option<&'static ActionDef>;

// ID resolution (keybinding initialization)
pub fn resolve_action_id(name: &str) -> Option<ActionId>;
```

### 13.4 Collision Detection

Collisions detected during registry initialization:

```rust
pub struct Collision<T> {
    pub kind: CollisionKind,  // Id, Name, Alias, Trigger
    pub key: String,
    pub winner: &'static T,
    pub shadowed: &'static T,
}
```

**Resolution**:
- Higher priority wins
- Same priority in debug mode: panic
- Same priority in release mode: warn, first registration wins

---

## 14. Testing Infrastructure

### 14.1 Unit Tests

Standard Rust unit tests for isolated logic:

```rust
#[cfg(test)]
mod tests {
    #[test]
    fn test_motion_left() {
        let text = Rope::from("hello");
        let range = Range::point(3);
        let result = (MOTION_MOVE_LEFT.handler)(text.slice(..), range, 1, false);
        assert_eq!(result.head, 2);
    }
}
```

### 14.2 GUI Integration Tests

**Location**: `crates/term/tests/`

Uses `kitty-test-harness` for real terminal testing:

```rust
#[test]
fn test_multiselect() {
    let harness = KittyHarness::new();
    harness.send_keys("i", "hello world", "esc");
    harness.send_keys("0", "w", "shift-w");  // Select word
    harness.assert_screen_contains("hello");
}
```

**Running GUI tests**:
```bash
KITTY_TESTS=1 DISPLAY=:0 cargo test -p evildoer-term --test kitty_multiselect -- --nocapture --test-threads=1
```

---

## 15. Common Implementation Patterns

### 15.1 Adding a New Action

```rust
// In crates/stdlib/src/actions/your_module.rs

action!(your_action, {
    description: "Description of what it does",
    bindings: r#"normal "x""#,  // Optional keybinding
}, |ctx| {
    // ctx.text - document content (RopeSlice)
    // ctx.cursor - cursor position (CharIdx)
    // ctx.selection - current selection (&Selection)
    // ctx.count - numeric prefix (usize)
    // ctx.extend - extend selection? (bool)

    // Return an ActionResult variant
    ActionResult::Motion(new_selection)
});
```

### 15.2 Adding a New Command

```rust
// In crates/stdlib/src/commands/your_command.rs

command!(your_command, {
    aliases: &["yc", "yourc"],
    description: "Description",
}, handler: your_command_handler);

fn your_command_handler<'a>(
    ctx: &'a mut CommandContext<'a>
) -> LocalBoxFuture<'a, Result<CommandOutcome, CommandError>> {
    Box::pin(async move {
        // Access editor via ctx methods
        // ctx.notify("info", "message")
        // ctx.require_edit()?

        Ok(CommandOutcome::Ok)
    })
}
```

### 15.3 Adding a New Hook

```rust
// In crates/stdlib/src/hooks/your_hook.rs

hook!(your_hook, BufferOpen, 500, "Description", |ctx| {
    if let HookEventData::BufferOpen { path, text, file_type } = &ctx.data {
        // Handle event
    }
    // Return unit () for Continue, or explicit HookAction
});
```

### 15.4 Adding a New Option

```rust
// In crates/stdlib/src/options/your_options.rs

option!(your_option, Bool, true, Global, "Description of option");
option!(buffer_option, Int, 4, Buffer, "Per-buffer option");
```

### 15.5 Adding a New Motion

```rust
// In crates/stdlib/src/motions/your_motion.rs

motion!(your_motion, {
    description: "Description",
}, |text, range, count, extend| {
    // Compute new range based on text and current range
    // Return the new Range
    Range::new(anchor, head)
});
```

### 15.6 Adding a New Text Object

```rust
// In crates/stdlib/src/objects/your_object.rs

fn your_object_inner(text: RopeSlice, pos: usize) -> Option<Range> {
    // Find inner bounds
}

fn your_object_around(text: RopeSlice, pos: usize) -> Option<Range> {
    // Find around bounds (including delimiters)
}

text_object!(your_object, {
    trigger: 'x',
    description: "Your text object",
}, {
    inner: your_object_inner,
    around: your_object_around,
});
```

---

## 16. Future Evolution: Proposed Macro Enhancements

### 16.1 Tier 1: Quick Wins

**symmetric_text_object!** - For objects where inner == around:
```rust
symmetric_text_object!(number, {
    trigger: 'n',
    description: "Number literal",
}, |text, pos| find_number_bounds(text, pos));
```

**bracket_pair_object!** - Reduce 4 definitions to 4 one-liners:
```rust
bracket_pair_object!(parentheses, '(', ')', 'b', &['(', ')']);
bracket_pair_object!(brackets, '[', ']', 'r', &['[', ']']);
```

### 16.2 Tier 2: Major Abstractions

**Unified hook with signature-inferred mutability**:
```rust
hook!(my_hook, BufferChange, 50, "desc",
    mutable |path: &Path, text: &mut Rope| {
        // Mutable access declared in signature
    }
);
```

**async_hook! for cleaner async**:
```rust
async_hook!(lsp_open, BufferOpen, 100, "LSP",
    async |path: PathBuf, text: String| {
        lsp.did_open(&path, &text).await;
    }
);
```

**#[extension] attribute**:
```rust
#[extension(id = "zenmode", priority = 50)]
pub struct ZenmodeState { ... }

impl ZenmodeState {
    #[init]
    pub fn new() -> Self { ... }

    #[hook(event = BufferChange)]
    pub fn on_change(&mut self, _editor: &Editor) { }

    #[render]
    pub fn on_render(&mut self, editor: &mut Editor) { }

    #[command("zen")]
    pub async fn toggle(&mut self, ctx: &mut CommandContext) -> CommandResult { }
}
```

### 16.3 Tier 3: Architectural

**events! macro for event schema**:
```rust
events! {
    EditorStart { },
    BufferOpen { path: Path, text: RopeSlice, file_type: Option<&str> },
    ModeChange { old_mode: Mode, new_mode: Mode },
}
// Generates HookEventData, OwnedHookContext, conversions
```

**Handler coverage checking**:
```rust
#[derive(DispatchResult)]
#[handler_coverage = "error"]
pub enum ActionResult { ... }
```

---

## 17. Anti-Patterns to Avoid

<high_risk_self_check>

Before implementing changes, verify you are NOT:

1. **Using direct `#[distributed_slice]`** when a macro exists
   - WRONG: `#[distributed_slice(ACTIONS)] static X: ActionDef = ...`
   - RIGHT: `action!(x, { ... }, |ctx| ...)`

2. **Creating new traits** when existing capability traits suffice
   - Check `EditorCapabilities` and its sub-traits first

3. **Adding fields to shared structs** without considering backward compatibility
   - Prefer optional fields with defaults

4. **Implementing side effects in action handlers**
   - Actions should be pure: `&ActionContext -> ActionResult`
   - Mutations happen in result handlers

5. **Hardcoding behavior** that should be configurable
   - Use `option!` macro for user-configurable values

6. **Creating new files** when adding to existing ones is cleaner
   - Group related functionality

7. **Skipping the macro system** for "just this one thing"
   - Consistency is more important than local optimization

8. **Ignoring existing patterns** in similar code
   - Match the style of surrounding code exactly

</high_risk_self_check>

---

## 18. Quick Reference Card

### File Locations

| What | Where |
|------|-------|
| Action definitions | `crates/stdlib/src/actions/*.rs` |
| Command definitions | `crates/stdlib/src/commands/*.rs` |
| Motion definitions | `crates/stdlib/src/motions/*.rs` |
| Text object definitions | `crates/stdlib/src/objects/*.rs` |
| Hook definitions | `crates/stdlib/src/hooks/*.rs` |
| Option definitions | `crates/stdlib/src/options/*.rs` |
| Statusline segments | `crates/stdlib/src/statusline/*.rs` |
| Result handlers | `crates/stdlib/src/editor_ctx/result_handlers/*.rs` |
| Extensions | `crates/extensions/extensions/*/mod.rs` |
| Macro definitions | `crates/manifest/src/macros.rs` |
| Proc macros | `crates/macro/src/*.rs` |
| Type definitions | `crates/manifest/src/*.rs` |

### Build Commands

```bash
# Standard build
nix develop -c cargo build

# Run tests
nix develop -c cargo test

# Run specific test
nix develop -c cargo test -p evildoer-stdlib test_name

# GUI tests (requires X11)
KITTY_TESTS=1 DISPLAY=:0 nix develop -c cargo test -p evildoer-term --test kitty_multiselect -- --nocapture --test-threads=1

# Check without building
nix develop -c cargo check

# Clippy lints
nix develop -c cargo clippy
```

### Key Types

| Type | Purpose | Location |
|------|---------|----------|
| `ActionResult` | Action return type | `manifest/src/actions.rs` |
| `ActionContext` | Read-only action input | `manifest/src/actions.rs` |
| `CommandContext` | Mutable command input | `manifest/src/commands.rs` |
| `HookContext` | Hook event data | `manifest/src/hooks.rs` |
| `EditorContext` | Mutable editor access | `manifest/src/editor_ctx/mod.rs` |
| `Selection` | Multi-cursor selection | `base/src/lib.rs` |
| `Range` | Single selection range | `base/src/range.rs` |
| `CharIdx` | Character index newtype | `base/src/range.rs` |
| `Mode` | Editor mode enum | `manifest/src/mode.rs` |
| `HandleOutcome` | Result handler return | `manifest/src/editor_ctx/handlers.rs` |

---

## 19. Conclusion

Evildoer represents a mature implementation of data-driven, macro-oriented architecture in Rust. The key principles are:

1. **Distributed slices** for zero-cost, cross-crate registration
2. **Declarative macros** that generate registration boilerplate
3. **Proc macros** for complex code generation (dispatch, keybinding parsing)
4. **Pure function actions** with side effects isolated to result handlers
5. **Capability-based access control** for optional editor features
6. **Lazy initialization** for runtime efficiency

When implementing changes, always prefer the macro system over manual registration, follow existing patterns exactly, and maintain the separation between declaration (manifest) and implementation (stdlib).

---

*This specification is designed for GPT-5.2 and equivalent advanced reasoning models. Follow the behavioral constraints in Section 2 for optimal results.*
