# AGENTS.md

> This file follows the [agents.md](https://agents.md/) open specification for agent-readable repository instructions.

# Todo List — Agent Instructions

This repository is a personal task queue system. Ideas and tasks live as markdown files that move through a pipeline: **inbox → in-progress → done**.

## Directory Semantics

| Directory | Meaning |
|-----------|---------|
| `inbox/` | Queued items waiting to be processed. FIFO order. |
| `in-progress/` | Item currently being worked on. Should have 0 or 1 file. |
| `done/` | Completed items. Never delete these — they are the audit trail. |
| `templates/` | Canonical templates for items and reports. Read-only reference. |
| `.agents/skills/` | Generic Agent Skills for this system (prefixed `todo-`). **Source of truth for all skills.** |
| `.claude/skills/` | Symlinks only — each entry points to the corresponding `.agents/skills/*/SKILL.md`. Do not add skill files here directly. |

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
| `todo-search` | `/todo-search <query>` | Search recent inbox items, claim the best match, and start or hand off immediate work |
| `todo-report` | `/todo-report` | Show queue status and recent completions |

## Adding New Skills

New skills must be created under `.agents/skills/<skill-name>/SKILL.md` — one directory per skill, following the [Agent Skills](https://agentskills.io) open standard. After adding a skill:

1. Add a symlink in `.claude/skills/` pointing to the new `SKILL.md`:
   ```sh
   ln -s "../../.agents/skills/<skill-name>/SKILL.md" ".claude/skills/<skill-name>.md"
   ```
2. Add the skill name to the `SKILLS` array in `install.sh`.
3. Commit both the new skill directory and the symlink.

Never put skill content directly in `.claude/skills/` — it is a compatibility shim for Claude Code, not the source of truth.

## Processing Rules

1. Sort `inbox/` lexicographically — the first file is next (oldest = highest priority by default).
2. Move to `in-progress/` before executing. This is the lock — check for existing in-progress files before starting.
3. Execute the **Task Prompt** section verbatim.
4. Append `## Result` with completion date and summary.
5. Move from `in-progress/` to `done/`.
6. If `inbox/` is empty, stop and report "Inbox empty."
