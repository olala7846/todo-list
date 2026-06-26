# todo-list

A minimal personal task queue powered by Claude Code. Ideas live as markdown files; a scheduled agent processes them one at a time while you're away.

## Getting Started

**Project-local** (skills available only inside this repo directory):

Clone the repo — skills in `.claude/skills/` are picked up automatically by Claude Code.

**Global install** (skills available from any directory):

```sh
git clone https://github.com/olala7846/todo-list
cd todo-list
./install.sh
```

The installer embeds the absolute repo path into the copied skill files so `/todo-intake`, `/todo-process`, and `/todo-report` always operate on the correct `inbox/`, `in-progress/`, and `done/` directories regardless of where you open Claude Code. Restart Claude Code after installing.

To reinstall after a `git pull` (picks up skill changes):

```sh
./install.sh
```

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
