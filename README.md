# todo-list

A minimal personal task queue for coding agents. Ideas live as markdown files; a scheduled or interactive agent processes them one at a time.

## Getting Started

**Project-local** (skills available only inside this repo directory):

Clone the repo. Skills live in `.agents/skills/` using the generic Agent Skills directory layout: one directory per skill, each with a `SKILL.md`.

**Global install** (skills available from any directory):

```sh
git clone https://github.com/olala7846/todo-list
cd todo-list
./install.sh
```

The installer embeds the absolute repo path into the copied skill files so `/todo-intake`, `/todo-process`, `/todo-report`, and `/todo-search` always operate on the correct `inbox/`, `in-progress/`, and `done/` directories regardless of where the agent session starts. Restart or reload your agent environment after installing if it discovers skills only at startup.

To reinstall after a `git pull` (picks up skill changes):

```sh
./install.sh
```

## How it works

```
/todo-intake  ->  inbox/  ->  /todo-process  ->  done/
                       |
                       +->  /todo-search <query>  ->  in-progress/
```

1. **Capture** an idea with `/todo-intake` - the agent asks clarifying questions and writes a structured markdown file to `inbox/`.
2. **Process** with `/todo-process [N]` - picks the oldest N items (FIFO), executes their task prompts, and archives results in `done/`.
3. **Search and start** with `/todo-search <query>` - searches the newest 10 inbox items, claims the best match, and starts or prints a handoff for immediate work.
4. **Review** with `/todo-report` - shows queue depth, in-progress items, recent completions, and anomalies.

Scheduling can be handled by any automation that invokes `/todo-process` on a cadence.

## Structure

```
inbox/        # queued items (FIFO by filename timestamp)
in-progress/  # active item (0 or 1 at a time)
done/         # completed items with appended results
templates/    # canonical item and report templates
.agents/skills/  # generic Agent Skills for this system
```

Files in `inbox/`, `in-progress/`, and `done/` are git-ignored — only the system scaffolding is tracked.

## Skills

| Command | Description |
|---------|-------------|
| `/todo-intake` | Capture a new idea into the inbox |
| `/todo-process [N]` | Process next N inbox items (default: 1) |
| `/todo-search <query>` | Search the newest 10 inbox items, claim the best match, and start or hand off immediate work |
| `/todo-report` | Status summary of the queue |
