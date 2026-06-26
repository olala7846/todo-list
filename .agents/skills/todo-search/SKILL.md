---
name: todo-search
description: Search recent todo-list inbox items by text query, claim the best match, and start or hand off immediate work. Use when the user invokes /todo-search with a query or asks to find and start a queued todo now.
---

# Todo Search

Use `/todo-search <some-text-query>` to find a queued todo that best matches the user's query and make it ready for immediate work. Use the todo-list repository that contains this skill unless this skill has been globally installed with absolute paths embedded.

## Repository Context

Before searching todos, understand which work repository the user is trying to work on:

1. Run `pwd`.
2. If inside a git repository, run `git rev-parse --show-toplevel`.
3. If available, inspect `git remote -v`.
4. Use the repo path, basename, and remote URL as matching signals and as context for the launched or fallback work session.

## Search and Claim

1. If the user did not provide a query after `/todo-search`, ask for the query and stop.
2. List all `.md` files in `in-progress/` excluding `.gitkeep`. If any exist, stop and report the active file path; do not claim another todo.
3. List `.md` files in `inbox/` excluding `.gitkeep`, sorted lexicographically descending. Consider only the newest 10.
4. If there are no candidates, report "Inbox is empty - nothing to search." and stop.
5. For each candidate, read the frontmatter and these sections when present: `## Goal`, `## Why`, `## Context`, `## Acceptance Criteria`, and `## Task Prompt`.
6. Rank candidates by semantic fit against the query and detected repository context. Give strongest weight to title, tags, repo/path mentions, acceptance criteria, and task prompt.
7. If no candidate is a reasonable fit, show the top 3 candidates with filenames and one-line reasons, leave all files in `inbox/`, and stop.
8. Move the best match from `inbox/` to `in-progress/` as the claim/lock before launching or printing handoff instructions.

## Launch or Handoff

After claiming the selected todo:

1. If the current agent environment can create a new work session, create a new session for the detected work repository and provide the prompt below.
2. If a new session cannot be created, print the prompt below as a direct handoff for the user or another agent.
3. If creating a new session fails after the file was moved, move the todo back from `in-progress/` to `inbox/`, report the failure, and stop.

Use this prompt shape for the launched or fallback session:

```markdown
Start working on this todo item now.

Todo file: <absolute path to in-progress todo file>
Target repository: <detected repository path, or "unknown">
Repository context: <repo basename and remote URL when available>

Read the todo file and execute its `## Task Prompt` section as literal instructions. Use the Goal, Context, and Acceptance Criteria in the same file as supporting context.

Before changing files in the target repository, read and follow its local agent instructions, including `AGENTS.md` if present.

When the task is complete, append this section to the todo file:

## Result
- **Completed:** <current datetime>
- **Summary:** <1-3 sentences describing what was done, caveats, and links to key outputs>

Then move the todo file from `in-progress/` to `done/`. Never delete todo files.
```

## Final Response

Report the selected title, original inbox filename, current `in-progress/` path, and whether a new session was created or a handoff prompt was printed.
