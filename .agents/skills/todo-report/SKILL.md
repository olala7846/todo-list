---
name: todo-report
description: Generate a concise status report for the todo-list queue. Use when the user invokes /todo-report or asks for todo queue status.
---

# Todo Report

Generate a status report for the todo system. Use `templates/report.md` as the structural reference. Use the todo-list repository that contains this skill unless this skill has been globally installed with absolute paths embedded.

## Steps

1. **In Progress**: List all `.md` files in `in-progress/` excluding `.gitkeep`. For each, extract the `title` from frontmatter and note the file's modification time as "started".

2. **Queue (Inbox)**: List all `.md` files in `inbox/` excluding `.gitkeep`, sorted lexicographically ascending. For each, extract `title` and `created` from frontmatter. Compute age as today minus created date.

3. **Recently Completed**: List all `.md` files in `done/` excluding `.gitkeep`, sorted by filename descending, newest first. Take up to the last 5. For each, extract `title` and the `## Result` section's **Completed** date and **Summary** line.

4. **Needs Attention**: Flag any of the following:
   - More than 1 file in `in-progress/`
   - Any file in `in-progress/` whose modification time is more than 24 hours ago
   - Any `.md` file in `inbox/` or `in-progress/` missing a `## Task Prompt` section or with an empty one
   - Any file missing required frontmatter fields: `title`, `created`

5. **Output the report** following the structure in `templates/report.md`. Keep it concise, one line per item in the queue and done lists.
