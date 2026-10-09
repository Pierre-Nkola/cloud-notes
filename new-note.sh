#!/usr/bin/env bash
# Usage: ./new-note.sh "Title of the note" [topic]
# Creates notes/<topic>/YYYY-MM-DD-slug.md, rebuilds the README index, and opens the note.
set -euo pipefail
cd "$(dirname "$0")"
title="${1:?Give a title}"; topic="${2:-general}"
slug=$(echo "$title" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-|-$//g')
file="notes/$topic/$(date +%F)-$slug.md"
mkdir -p "notes/$topic"
[ -e "$file" ] || cat > "$file" <<NOTE
# $title

**Problem.** What were you trying to do, and what got in the way?

**What worked.** The fix, with the commands or code.

**Why it matters.** One or two sentences on when someone else would hit this.
NOTE
# rebuild index
{
  sed '/<!-- index:start -->/q' README.md
  find notes -name '*.md' | sort -r | while read -r f; do
    echo "- [$(head -1 "$f" | sed 's/^# //')]($f) · $(basename "$(dirname "$f")")"
  done
  sed -n '/<!-- index:end -->/,$p' README.md
} > README.tmp && mv README.tmp README.md
"${EDITOR:-nano}" "$file"
echo "When done: git add -A && git commit -m \"note: $title\" && git push"
