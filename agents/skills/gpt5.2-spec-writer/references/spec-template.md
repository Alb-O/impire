# [Project Name]: Agent Specification

## Model Directive

This document serves as a specification for GPT-5.2 to [Core Objective]. [Brief context about the project/architecture].

---

## CRITICAL: Implementation Expectations

<mandatory_execution_requirements>

This is NOT a documentation-only task. When given implementation requests:

1. EDIT FILES using tools to modify actual source files
2. DEBUG AND FIX by running builds, reading errors, iterating until it compiles
3. TEST CHANGES as appropriate
4. COMPLETE FULL IMPLEMENTATION; do not stop at partial solutions

Unacceptable responses:
- "Here's how you could implement this..."
- Providing code blocks without writing them to files
- Stopping after encountering the first error

</mandatory_execution_requirements>

---

## Behavioral Constraints

<verbosity_and_scope_constraints>

- Produce MINIMAL code changes that satisfy the requirement
- PREFER editing existing files over creating new ones
- NO extra features, no added components, no architectural embellishments
- If any instruction is ambiguous, choose the simplest valid interpretation
- Follow existing code patterns exactly

</verbosity_and_scope_constraints>

<design_system_enforcement>

- Explore the existing patterns deeply before proposing changes
- Implement EXACTLY and ONLY what is requested
- Do NOT invent new patterns when existing ones suffice

</design_system_enforcement>

---

## Implementation Roadmap

[Define concrete, numbered phases with explicit tasks]

### Phase 1: [Phase Name]

Objective: [What this phase accomplishes]

Tasks:
- 1.1 [Task]: File `path/to/file` -> Steps: Read, Edit X, Run check -> Done: builds pass
- 1.2 [Task]: ...

### Phase 2: [Phase Name]

...

---

## Architecture

[Describe the core architecture, key patterns, directory structure]

---

## Anti-Patterns

1. [Anti-Pattern]: [Why bad] -> [Do this instead]
