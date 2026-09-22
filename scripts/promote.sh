#!/bin/sh
# Promote the skills from vimulatus/agentic into this repo, one commit per skill.
#   promote.sh [-n] [-s <agentic-checkout>]     -n prints the plan and stops.
# `.skillsignore` holds the skills that stay personal: promote never copies one,
# and removes it here when an earlier promote published it.
set -eu
dry=""
src=""
while [ $# -gt 0 ]; do
  case "$1" in
    -n) dry=1 ;;
    -s) shift; src=${1:?usage: promote.sh [-n] [-s <agentic-checkout>]} ;;
    *) echo "usage: promote.sh [-n] [-s <agentic-checkout>]" >&2; exit 2 ;;
  esac
  shift
done

# The root is the script's own repo, so promote works from any working directory.
root=$(cd "$(dirname "$0")/.." && pwd)
src=${src:-$root/../agentic}
[ -d "$src/skills" ] || { echo "no skills/ under $src: pass the agentic checkout with -s" >&2; exit 1; }
src=$(cd "$src" && pwd)
sha=$(git -C "$src" rev-parse --short HEAD)
[ -z "$(git -C "$src" status --porcelain)" ] || echo "warning: $src is dirty, so $sha does not describe what you promote" >&2
[ -n "$dry" ] || [ -z "$(git -C "$root" status --porcelain)" ] || { echo "commit or stash first: the tree is dirty" >&2; exit 1; }

ignore=$root/.skillsignore
patterns=""
if [ -f "$ignore" ]; then
  patterns=$(sed -e 's/#.*//' -e 's/[[:space:]]*$//' "$ignore" | grep -v '^$' || true)
fi

ignored() {
  for p in $patterns; do
    case "$1" in $p) return 0 ;; esac
  done
  return 1
}

# Every copy drops Vasu's name: these skills are read by people who are not him.
depersonalize() {
  find "$1" -type f | while IFS= read -r f; do
    grep -Iq . "$f" || continue
    sed -e "s/Vasu's/the user's/g" -e 's/Vasu/the user/g' \
        -e 's/^the user/The user/' -e 's/\([.!?|] \)the user/\1The user/g' \
        "$f" > "$f.promote"
    cat "$f.promote" > "$f"   # write back in place: `mv` would drop the executable bit
    rm -f "$f.promote"
  done
}

copied=0 dropped=0 skipped=0
for d in "$src"/skills/*/*/; do
  [ -f "$d/SKILL.md" ] || continue
  name=$(basename "$d")
  dest=$root/skills/$name
  if ignored "$name"; then
    if [ -d "$dest" ]; then
      echo "drop    $name (ignored, published here)"
      dropped=$((dropped + 1))
      [ -n "$dry" ] && continue
      git -C "$root" rm -rq "skills/$name"
      git -C "$root" commit -qm "chore($name): drop, ignored"
    else
      echo "skip    $name (ignored)"
      skipped=$((skipped + 1))
    fi
    continue
  fi
  echo "copy    $name"
  copied=$((copied + 1))
  [ -n "$dry" ] && continue
  rm -rf "$dest"
  cp -R "$d" "$dest"
  depersonalize "$dest"
  git -C "$root" add -A "skills/$name"
  if ! git -C "$root" diff --cached --quiet; then
    git -C "$root" commit -qm "feat($name): promote from agentic@$sha"
  fi
done

for dest in "$root"/skills/*/; do
  [ -d "$dest" ] || continue
  name=$(basename "$dest")
  found=""
  for d in "$src"/skills/*/"$name"; do [ -d "$d" ] && found=1; done
  [ -n "$found" ] || echo "warning: skills/$name is published here but is not in agentic" >&2
done

echo "$copied copied, $dropped dropped, $skipped skipped, from agentic@$sha"

if [ -z "$dry" ]; then
  left=$(grep -rlEi '\bVasu\b|\b(he|his|him)\b' "$root/skills" || true)
  [ -z "$left" ] || { echo "warning: a line still names Vasu, or calls the reader he. Read these:" >&2; echo "$left" >&2; }
fi

# The README catalogues each skill by hand, under a display name: `browser-evidence` reads `**Browser evidence**`.
for p in $patterns; do
  title=$(printf '%s' "$p" | sed 's/-/[ -]/g')
  if grep -qiE "\*\*$title\*\*" "$root/README.md" 2>/dev/null; then
    echo "warning: README.md still catalogues $p. Remove its entry by hand." >&2
  fi
done
exit 0
