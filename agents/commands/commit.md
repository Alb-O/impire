---
allowed-tools: Bash
description: Create a git commit
---

- Current git status: !`git status`
- Current git diff (staged and unstaged changes): !`git diff HEAD`
- Current branch: !`git branch --show-current`
- Recent commits: !`git log --oneline -10`

Also use relevant work done in the conversation context to add useful detail to the commit description.

Based on the above changes, create a single git commit with NO `Co-authored-by` line.
