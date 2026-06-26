# todo-list

A minimal personal task queue powered by Claude Code. Ideas live as markdown files; a scheduled agent processes them one at a time while you're away.

## How it works

```
/todo-intake  →  inbox/  →  /todo-process  →  done/
```

1. **Capture** an idea with `/todo-intake` — the agent asks clarifying questions and writes a structured markdown file to `inbox/`.
2. **Process** with `/todo-process [N]` — picks the oldest N items (FIFO), executes their task prompts, and archives results in `done/`.
3. **Review** with `/todo-report` — shows queue depth, in-progress items, recent completions, and anomalies.

Scheduling is handled via `/schedule` to run the processor automatically on a cadence.

## Structure

```
inbox/        # queued items (FIFO by filename timestamp)
in-progress/  # active item (0 or 1 at a time)
done/         # completed items with appended results
templates/    # canonical item and report templates
.claude/skills/  # todo-intake, todo-process, todo-report
```

Files in `inbox/`, `in-progress/`, and `done/` are git-ignored — only the system scaffolding is tracked.

## Skills

| Command | Description |
|---------|-------------|
| `/todo-intake` | Capture a new idea into the inbox |
| `/todo-process [N]` | Process next N inbox items (default: 1) |
| `/todo-report` | Status summary of the queue |
