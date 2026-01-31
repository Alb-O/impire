---
allowed-tools: Bash
description: Create a git commit
---

- Current git status: !`git status`
- Recent commits (replicate msg style): !`git log --oneline -10`
- Current branch: !`git branch --show-current`
- Current git diff (staged and unstaged changes): !`git diff HEAD`

Also use relevant work done in the conversation context to add useful detail to the commit description. Do not reference other commit hashes in the description.

Based on the above changes, create a single git commit with NO `Co-authored-by` line.
