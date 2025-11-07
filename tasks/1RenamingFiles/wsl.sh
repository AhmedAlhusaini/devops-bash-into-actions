#!/usr/bin/bash
# --- change this to your real WSL/Linux path ---
labs_dir="/mnt/d/Labs"

cd "$labs_dir" || { echo "❌ Cannot find $labs_dir"; exit 1; }

shopt -s nullglob           # skip loop if no matches
for f in *_Lab*; do
  tail="${f#*_Lab}"         # remove everything up to first “_Lab”
  new="Lab${tail}"
  if [[ "$f" != "$new" ]]; then
    mv -i -- "$f" "$new"
    echo "✅  $f  →  $new"
  fi
done
