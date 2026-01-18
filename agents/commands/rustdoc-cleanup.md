---
description: Cleanup inline comments into rustdoc docstrings
---

Review the current work for inline comments. Consolidate useful technical information into proper rustdoc docstrings:

1. Remove inline comments that explain *what* (code should be self-documenting)
2. Move comments explaining *why* - move these into /// or //! docstrings
3. Follow rustdoc conventions: Use `# Examples`, `# Panics`, `# Errors`, `# Safety` sections where appropriate
4. Delete redundant or obvious comments
5. Delete comments used for section markers

Do NOT outright remove docstrings, especially from pubs

Additionally, briefly rework any inelegant or verbose code (e.g. check for tramp data, unecessary vars that could be inlined, performative error handling, etc.)
