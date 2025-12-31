---
name: gpt5.2-spec-writer
description: Guide for writing effective prompt specifications (specs) for the GPT-5.2 Codex agent. Use when the user asks to "write a prompt spec", "create a system prompt for GPT-5.2", "design a spec for an agent", or "how to prompt GPT-5.2".
---

# GPT-5.2 Spec Writer

Guide for writing prompt specifications tailored for GPT-5.2. The model excels at structured reasoning and instruction following but benefits from explicit constraints on verbosity and scope.

## How to Write a Spec

A spec is a markdown document defining persona, constraints, architecture, and operational rules for an agent.

1. Start with [references/spec-template.md](references/spec-template.md)
2. Fill in project-specific sections (directive, architecture, conventions)
3. Consult [references/gpt5.2-checklist.md](references/gpt5.2-checklist.md) to verify coverage

## Key Patterns

### Explicit Task Roadmaps

Every spec MUST include an objective, actionable sequence of tasks. GPT-5.2 performs best with concrete work items and clear completion criteria, not abstract guidance.

- Numbered phases with measurable objectives
- Specific file paths and function names
- Concrete steps: Read X -> Edit Y -> Run Z
- Completion criteria for each task

Avoid vague instructions like "improve the code". Be specific: "Fix the null check in parse_config() at line 42".

### XML Constraint Blocks

Use XML tags to define distinct rule sets:
- `<mandatory_execution_requirements>` - execution loop (Read -> Edit -> Verify)
- `<verbosity_and_scope_constraints>` - output size and scope control
- `<design_system_enforcement>` - adhering to existing patterns

### Chain of Verification

Instruct the model to verify its work: Edit -> Build/check -> Fix -> Report only when complete.

## References

- [Spec Template](references/spec-template.md)
- [GPT-5.2 Checklist](references/gpt5.2-checklist.md)
- [GPT-5.2 Model Guide](references/gpt5.2-model.md)
