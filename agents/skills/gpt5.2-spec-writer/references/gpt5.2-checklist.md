# GPT-5.2 Prompting Checklist

## 1. Task Structure (CRITICAL)
- [ ] Explicit roadmap with numbered phases and measurable objectives
- [ ] Concrete steps: Read X -> Edit Y -> Verify Z
- [ ] Completion criteria for each task/phase
- [ ] Specific file paths, function names where applicable
- [ ] No vague instructions ("improve", "fix issues", "clean up")

## 2. Verbosity & Scope
- [ ] Clear length constraints
- [ ] Explicitly forbid extra features and "gold-plating"
- [ ] Use `<verbosity_and_scope_constraints>` tags

## 3. Tool Usage
- [ ] Encourage parallel tool use for independent operations
- [ ] Require verification after edits (run build, run tests)

## 4. Context Management
- [ ] For large inputs (>10k tokens), include `<long_context_handling>`
- [ ] Anchor claims to specific sections/lines

## 5. Agentic Behavior
- [ ] Brief, outcome-focused updates ("Found X", "Updated Y")
- [ ] "Do not expand the task beyond what is asked"
