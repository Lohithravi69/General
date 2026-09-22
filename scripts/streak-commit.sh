#!/usr/bin/env bash
set -euo pipefail

# GitHub Streak Contribution Script (Bash / WSL / macOS / Linux)
AUTHOR_NAME="${AUTHOR_NAME:-Lohith Ravi}"
AUTHOR_EMAIL="${AUTHOR_EMAIL:-lohitravi69@gmail.com}"
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

cd "$REPO_DIR"

echo "=== GitHub Streak Contribution Runner ==="
echo "Repository: $REPO_DIR"
echo "Author: $AUTHOR_NAME <$AUTHOR_EMAIL>"

mkdir -p daily
TODAY="$(date +'%Y-%m-%d')"
TIMESTAMP="$(date -u +'%Y-%m-%dT%H:%M:%SZ')"

FILE_ONE="daily/file-one-${TODAY}.txt"
FILE_TWO="daily/file-two-${TODAY}.txt"

echo "Daily streak contribution at ${TIMESTAMP}" > "$FILE_ONE"
echo "Daily streak contribution at ${TIMESTAMP}" > "$FILE_TWO"

git add "$FILE_ONE" "$FILE_TWO"

if git diff --cached --quiet; then
  echo "No staged changes detected."
else
  COMMIT_MSG="chore: daily streak contribution [${TODAY}]"
  git -c user.name="$AUTHOR_NAME" -c user.email="$AUTHOR_EMAIL" commit -m "$COMMIT_MSG" --author="$AUTHOR_NAME <$AUTHOR_EMAIL>"
  echo "Created commit: $COMMIT_MSG"
fi

if [ "${1:-}" = "--push" ] || [ "${PUSH:-}" = "true" ]; then
  echo "Pushing to origin/main..."
  git push origin main
  echo "Push successful!"
else
  echo "To push changes, run: git push origin main"
fi
