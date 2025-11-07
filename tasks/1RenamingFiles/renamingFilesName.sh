#!/bin/bash
path='C:/Bash'
cd "$path" || { echo "❌ Cannot find $path"; exit 1; }

for file in *_Lab*; do
  # Extract lab number
  lab_number=$(echo "$file" | grep -oP '(?<=_Lab )\d+')
  
  # Rename only Lab 1
  if [[ "$lab_number" == "1" ]]; then
    new_name=$(echo "$file" | sed -E 's/^[^_]+_Lab /Lab /')
    mv "$file" "$new_name"
    echo "Renamed: $file → $new_name"
  else
    rm "$file"
    echo "Deleted: $file"
  fi
done