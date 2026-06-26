#!/usr/bin/env bash
set -euo pipefail

REPO_PATH="$(cd "$(dirname "$0")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
SKILLS=("todo-intake" "todo-process" "todo-report")

mkdir -p "$DEST"

echo "Installing todo-list skills from $REPO_PATH"
echo "Destination: $DEST"
echo ""

for skill in "${SKILLS[@]}"; do
  src="$REPO_PATH/.claude/skills/$skill.md"
  dst="$DEST/$skill.md"

  # Replace relative directory tokens with absolute paths rooted at the repo.
  # These tokens match exactly the path prefixes used in the skill files.
  sed \
    -e "s|inbox/|$REPO_PATH/inbox/|g" \
    -e "s|in-progress/|$REPO_PATH/in-progress/|g" \
    -e "s|done/|$REPO_PATH/done/|g" \
    -e "s|templates/|$REPO_PATH/templates/|g" \
    "$src" > "$dst"

  echo "  ✓ $skill"
done

echo ""
echo "Done. Restart Claude Code for the skills to take effect."
echo "Skills installed: /todo-intake  /todo-process [N]  /todo-report"
