#!/usr/bin/env bash
set -euo pipefail

REPO_PATH="$(cd "$(dirname "$0")" && pwd)"
DEST="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
SKILLS=("todo-intake" "todo-process" "todo-report")
LINK=false

for arg in "$@"; do
  case "$arg" in
    --link) LINK=true ;;
    *) echo "Unknown argument: $arg"; exit 1 ;;
  esac
done

mkdir -p "$DEST"

echo "Installing todo-list skills from $REPO_PATH"
echo "Destination: $DEST"
if $LINK; then
  echo "Mode: symlink (skills reflect repo changes instantly)"
  echo "Note: symlinked skills use relative paths — they work correctly only"
  echo "      when Claude Code is opened in the repo directory."
fi
echo ""

for skill in "${SKILLS[@]}"; do
  src="$REPO_PATH/.claude/skills/$skill.md"
  dst="$DEST/$skill.md"

  rm -f "$dst"

  if $LINK; then
    ln -s "$src" "$dst"
  else
    # Replace relative directory tokens with absolute paths rooted at the repo.
    sed \
      -e "s|inbox/|$REPO_PATH/inbox/|g" \
      -e "s|in-progress/|$REPO_PATH/in-progress/|g" \
      -e "s|done/|$REPO_PATH/done/|g" \
      -e "s|templates/|$REPO_PATH/templates/|g" \
      "$src" > "$dst"
  fi

  echo "  ✓ $skill"
done

echo ""
echo "Done. Restart Claude Code for the skills to take effect."
echo "Skills installed: /todo-intake  /todo-process [N]  /todo-report"
