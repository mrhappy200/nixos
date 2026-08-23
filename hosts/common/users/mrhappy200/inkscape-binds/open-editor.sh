#!/usr/bin/env bash

# Config
fontsize=10
font="monospace"


tmpfile=$(mktemp --suffix=-inkscape-editor.tex)
echo "Editing: $tmpfile"
emacsclient -c $tmpfile

latex=$(<$tmpfile)

echo "LaTeX: $latex"

IFS='' read -r -d '' svg <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="no"?>
    <svg>
      <text
         style="font-size:${fontsize}px; font-family:'${font}';-inkscape-font-specification:'${font}, Normal';fill:#000000;fill-opacity:1;stroke:none;"
         xml:space="preserve"><tspan sodipodi:role="line" >${latex}</tspan></text>
    </svg>
EOF

echo "SVG: $svg"

printf '%s' "$svg" | wl-copy
# CTRL:1 V:1 V:0 CTRL:0
ydotool key 29:1 47:1 47:0 29:0
