#!/bin/sh

find . -name '*.wav' | while read i ; do
    BASE="$(dirname "$i")/$(basename "$i" .wav)"
    TITLE="$(basename "$i")"

    [ "$i" -nt "$BASE.mp3" ] && lame -b 32 -V 5 -q 5 -m j "$i" "$BASE.mp3" --tt "$TITLE" --ta "j. shagam @ metronomic.tk" --tl "Global Game Jam 2016" --ty 2016
    [ "$i" -nt "$BASE.ogg" ] && oggenc "$i" -o "$BASE.ogg" -t "$TITLE" -a "j. shagam @ metronomic.tk"
    [ "$i" -nt "$BASE.flac" ] && flac "$i" -o "$BASE.flac"
done

(
cat << EOF
<!DOCTYPE html>
<html>
<head>
<title>Global Game Jam 2016 music</title>

<!-- jQuery -->
<script src="js/jquery-1.11.0.min.js"></script>

<!-- jPlayer -->
<link type="text/css" href="js/jplayer/skin/blue.monday/jplayer.blue.monday.css" rel="stylesheet" />
<script type="text/javascript" src="js/jplayer/jquery.jplayer.min.js"></script>
<script type="text/javascript" src="js/jplayer/add-on/jplayer.playlist.min.js"></script>
<script type="text/javascript" src="js/jplayer/add-on/jplayer.jukebox.min.js"></script>

<script type="text/javascript">
   // Initialize jPlayerJukebox
   jQuery(document).ready(function(){
      var jpjb = new jPlayerJukebox({
         swfPath: 'js/jplayer'
      });
   });
</script>

</head>

<body>
    <p>Here is the music I've made for this year's Global Game Jam (2016). Please see <a href="https://github.com/plaidfluff/ggj2016-music">my GitHub repo</a> for more information.</p>
<table>
EOF

lastdir=''
find . -type f -name '*.mp3' | sort | while read mp3 ; do
    dir="$(dirname "$mp3" | cut -f2- -d/)"
    if [ "$dir" != "$lastdir" ]; then
        printf '<tr><th colspan=5>%s</th></tr>' "$dir"
        lastdir="$dir"
    fi
    basename="$(basename "$mp3" .mp3)"
    pathpart="$(dirname "$mp3")/$basename"
    fmtime="$(stat -t "%Y-%m-%d %H:%M" -f %Sm "$mp3")"
    printf '<tr><td>%s</td><td>%s</td><td><a href="%s">mp3</a></td><td><a href="%s.ogg">ogg</a></td><td><a href="%s.flac">flac</a></td></tr>' "$fmtime" "$basename" "$mp3" "$pathpart" "$pathpart"
done
printf '</table>'

cat << EOF
</ul>
</body></html>
EOF
) > index.html