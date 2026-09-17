#!/bin/sh
# Release the promoted skills: push main, which is what consumers install from.
#   release.sh [-n]     -n prints what would ship and stops.
set -eu
dry=""
for a in "$@"; do case "$a" in -n) dry=1 ;; *) echo "usage: release.sh [-n]" >&2; exit 2 ;; esac; done

root=$(git rev-parse --show-toplevel)
branch=$(git -C "$root" branch --show-current)
[ "$branch" = main ] || { echo "releases run from main, not $branch" >&2; exit 1; }
[ -z "$(git -C "$root" status --porcelain)" ] || { echo "commit or stash first: the tree is dirty" >&2; exit 1; }

git -C "$root" fetch -q origin
if git -C "$root" rev-parse -q --verify origin/main >/dev/null; then
  [ "$(git -C "$root" rev-list --count main..origin/main)" = 0 ] || { echo "main is behind origin: git pull --rebase first" >&2; exit 1; }
  range=origin/main..HEAD
else
  range=HEAD
fi

log=$(git -C "$root" log --oneline "$range")
[ -n "$log" ] || { echo "nothing to release"; exit 0; }
echo "$log"
[ -z "$dry" ] || exit 0

git -C "$root" push -q -u origin main
echo "released $(git -C "$root" rev-parse --short HEAD)"
