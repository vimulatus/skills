#!/bin/sh
# Find media in a PR or issue body that GitHub will not render inline.
#   check-embeds.sh <body.md>   -> prints each offending line; exit 1 when there is one
# Works before `--attach`, on local paths, and after, on the user-attachments URLs it writes.
# Passes: `![claim](path)` alone on its line, a bare video path or asset URL alone on its line,
# and a table row of image cells. Everything else that names media fails.
set -eu
body=${1:?usage: check-embeds.sh <body.md>}
img='[^ )]+\.(png|jpe?g|gif|webp|svg)'
vid='[^ )]+\.(mp4|mov|webm)'
asset='https://[^ )]*user-attachments/assets/[^ )]+'
media="($img|$vid|$asset)"
bad=$(grep -nE "$media" "$body" \
  | grep -vE "^[0-9]+: *!\[[^]]+\]\($media\)$" \
  | grep -vE "^[0-9]+: *($vid|$asset)$" \
  | grep -vE "^[0-9]+:\|( !\[[^]]*\]\($img\) \|)+$" || true)
[ -z "$bad" ] && exit 0
echo "$bad"
exit 1
