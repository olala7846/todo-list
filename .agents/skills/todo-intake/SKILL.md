---
name: todo-intake
description: Capture a new idea or task into the todo-list inbox. Use when the user invokes /todo-intake or asks to add something to the personal todo queue.
---

# Todo Intake

Read `templates/todo-item.md` to understand the expected item structure. Use the todo-list repository that contains this skill unless this skill has been globally installed with absolute paths embedded.

Your job is to capture a new todo item with enough context that a future agent can execute it unattended. Be a thoughtful collaborator, not just a scribe.

## Process

1. **Understand the idea first.** Ask the user to describe what they want to do in one or two sentences if they have not already.

2. **Challenge and clarify.** Ask only about details that are unclear or underdeveloped:
   - **Goal**: What does "done" look like, concretely? How will you know it worked?
   - **Why**: What problem does this solve? Is there a simpler approach that achieves the same outcome?
   - **Scope**: What should explicitly not change? Are there related systems that could be affected?
   - **Context**: What background does the executing agent need? Include file paths, repo names, links, and prior decisions.
   - **Acceptance criteria**: What are the 2-5 specific things that must be true when this is complete?

3. **Draft the Task Prompt.** Write it as instructions to a capable but context-free agent. Include what to do, where to do it with specific paths or repos, and how to verify it worked. If the user's task is vague here, push back: "The agent runs unattended - what exactly should it do first?"

4. **Compose the file.** Once you have enough context, generate the markdown file following `templates/todo-item.md`. Use a slug derived from the title: lowercase, hyphens, no special characters.

5. **Write the file** to `inbox/` with the filename format `YYYY-MM-DDTHH-MM-SS-<slug>.md` using the current timestamp.

6. **Confirm.** Tell the user the filename created and show the composed Task Prompt for a final sanity check.

## Tone

Be direct. Push back on vague requirements. A well-scoped item now saves debugging an incomplete execution later.
