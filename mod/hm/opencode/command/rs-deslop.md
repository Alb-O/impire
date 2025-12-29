---
description: Un-shittify Rust code
---

The changes look to be working fine, but we'd like to limit the ammount of 'code churn' and unnecessary content in the repository.

Start by inspecting what you are actually changing:

`git add -N .; git diff` if diff is relatively small, or, if changes are very large, manually read files of interest.

Separate behavioural changes from churn. As you review, actively avoid Rust-shaped noise:

✗ Inline comments that don’t match the project’s tone or that narrate obvious control flow.
✗ Defensive branches that assume impossible states on trusted codepaths (extra `match _ =>`, redundant `if let Some` guards, spurious fallbacks) unless you can point to a concrete invariant break.
✗ Error handling that’s performative: turning simple `?` propagation into verbose `map_err` chains, adding “just in case” `catch_unwind`, or plumbing new error enums when an existing error type already expresses the failure. Consider that it may be better to let some code paths that should theoretically be invalid panic clearly.
✗ Type escape hatches (`Box<dyn Any>`, casts to silence the compiler) unless the area already uses that pattern and you can justify it mechanically.
✗ Tramp data and excessive named variables where they should really be inlined.
✗ Section markers/decorative comments; remove these, not professional looking. Organization is implied by code structure and naming, not adhoc seperators.

✓ Keep/add comprehensive, technical docstrings. These are important for rustdoc, and should be added to all public API.
✓ Follow rustdoc best practices (intra-doc links for type ref, standard headings e.g. `# Errors, # Arguments`)

Once the non-essential lines are identified, clean them up while keeping identical observable behaviour. Prefer minimal diffs: keep signatures stable, keep error shapes stable, keep logging consistent, keep module and crate boundaries clean.
