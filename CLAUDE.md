# Todo List — Agent Instructions

This repository is a personal task queue system. Ideas and tasks live as markdown files that move through a pipeline: **inbox → in-progress → done**.

## Directory Semantics

| Directory | Meaning |
|-----------|---------|
| `inbox/` | Queued items waiting to be processed. FIFO order. |
| `in-progress/` | Item currently being worked on. Should have 0 or 1 file. |
| `done/` | Completed items. Never delete these — they are the audit trail. |
| `templates/` | Canonical templates for items and reports. Read-only reference. |
| `.claude/skills/` | Skills for this system (prefixed `todo-`). |

**Never delete files. Only move them between directories.**

## File Naming Convention

All todo items use a sortable timestamp prefix:

```
YYYY-MM-DDTHH-MM-SS-<slug>.md
```

Example: `2026-06-26T14-30-00-add-dark-mode.md`

Lexicographic sort = chronological order = FIFO. The oldest file in `inbox/` (sorted ascending) is always next.

## Item File Format

```markdown
---
title: "Human-readable title"
created: "2026-06-26T14:30:00"
tags: [tag1, tag2]
---

## Goal
## Why
## Context
## Acceptance Criteria
## Task Prompt
```

When processing is complete, the processor appends:

```markdown
## Result
- **Completed:** YYYY-MM-DDTHH:MM:SS
- **Summary:** What was done, any caveats, links to artifacts.
```

## Skills

| Skill | Trigger | Purpose |
|-------|---------|---------|
| `todo-intake` | `/todo-intake` | Capture a new idea into inbox |
| `todo-process` | `/todo-process [N]` | Process next N items (default: 1) |
| `todo-report` | `/todo-report` | Show queue status and recent completions |

## Processing Rules

1. Sort `inbox/` lexicographically — the first file is next (oldest = highest priority by default).
2. Move to `in-progress/` before executing. This is the lock — check for existing in-progress files before starting.
3. Execute the **Task Prompt** section verbatim.
4. Append `## Result` with completion date and summary.
5. Move from `in-progress/` to `done/`.
6. If `inbox/` is empty, stop and report "Inbox empty."
