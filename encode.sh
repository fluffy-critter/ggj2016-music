#!/bin/sh

for i in "$@"; do
    BASE="$(dirname "$i")/$(basename "$i" .wav)"
    TITLE="$(basename "$i")"

    [ "$i" -nt "$BASE.mp3" ] && lame -b 32 -V 5 -q 5 -m j "$i" "$BASE.mp3" --tt "$TITLE" --ta "j. shagam @ metronomic.tk" --tl "Global Game Jam 2016" --ty 2016
    [ "$i" -nt "$BASE.ogg" ] && oggenc "$i" -o "$BASE.ogg" -t "$TITLE" -a "j. shagam @ metronomic.tk"
    [ "$i" -nt "$BASE.flac" ] && flac "$i" -o "$BASE.flac"
done
