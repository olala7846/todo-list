#!/usr/bin/env bash
set -euo pipefail

REPO_PATH="$(cd "$(dirname "$0")" && pwd)"
DEST="${AGENT_SKILLS_DIR:-$HOME/.agents/skills}"
SKILLS=("todo-intake" "todo-process" "todo-report" "todo-search")
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
  echo "      when the agent session is opened in the repo directory."
fi
echo ""

for skill in "${SKILLS[@]}"; do
  src="$REPO_PATH/.agents/skills/$skill"
  dst="$DEST/$skill"

  rm -rf "$dst"

  if $LINK; then
    ln -s "$src" "$dst"
  else
    mkdir -p "$dst"
    # Replace relative directory tokens with absolute paths rooted at the repo.
    sed \
      -e "s|inbox/|$REPO_PATH/inbox/|g" \
      -e "s|in-progress/|$REPO_PATH/in-progress/|g" \
      -e "s|done/|$REPO_PATH/done/|g" \
      -e "s|templates/|$REPO_PATH/templates/|g" \
      "$src/SKILL.md" > "$dst/SKILL.md"
  fi

  echo "  ✓ $skill"
done

echo ""
echo "Done. Restart or reload your agent environment if it discovers skills only at startup."
echo "Skills installed: /todo-intake  /todo-process [N]  /todo-search <query>  /todo-report"
