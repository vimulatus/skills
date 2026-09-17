#!/bin/sh
# Swap a stale screenshot for a fresh one, keeping its place in the PR body.
#   refresh-shot.sh <pr> <file> "<alt text>"
# The old URL is opaque and carries no reference to the file, so the alt text
# is the anchor: find `![<alt text>](url)` in the body, put the local file
# back in its place, and let `--attach` upload and rewrite it.
set -eu
pr=${1:?usage: refresh-shot.sh <pr> <file> "<alt text>"}
file=${2:?path to the new shot}
alt=${3:?the alt text already in the body, exactly as written}

esc_grep=$(printf '%s' "$alt" | sed -e 's/[.[\*^$]/\\&/g')
esc_sed=$(printf '%s' "$alt" | sed -e 's/[.[\*^$&/\]/\\&/g')

body=$(mktemp)
gh pr view "$pr" --json body --jq .body > "$body"
if ! grep -qE "!\[$esc_grep\]\([^)]+\)" "$body"; then
  echo "no ![$alt](...) in the body of #$pr. Attach $file and write the reference yourself." >&2
  exit 1
fi
sed -E -i.bak "s#!\[$esc_sed\]\([^)]+\)#![$esc_sed]($(printf '%s' "$file" | sed -e 's/[&/\]/\\&/g'))#" "$body"
gh pr edit "$pr" --body-file "$body" --attach "$file"

gh pr view "$pr" --json body --jq .body | grep -oE "!\[$esc_grep\]\([^)]+\)"
