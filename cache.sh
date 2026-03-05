#!/usr/bin/env bash


CONFIG="$1/config.json"



wallpaper_path=$(jq -r '.wallpaper_path' "$CONFIG")
cache_path=$(jq -r '.cache_path' "$CONFIG")

mkdir -p "$cache_path"

echo "Wallpaper path: $wallpaper_path"
echo "Cache path: $cache_path"

find "$wallpaper_path" -type f \( \
    -iname "*.jpg" -o \
    -iname "*.jpeg" -o \
    -iname "*.png" -o \
    -iname "*.webp" \
\) | while read -r img; do

    filename=$(basename "$img")
    out="$cache_path/$filename"

    if [[ -f "$out" ]]; then
        continue
    fi

    echo "Generating thumbnail for $filename"

    convert "$img" \
        -thumbnail x500 \
        -strip \
        -quality 85 \
        "$out" &

done

wait

echo "Thumbnail generation complete."
