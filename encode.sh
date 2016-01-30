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

<style>
table {border-collapse: collapse; border: solid black 3px; }
table td { border: solid black 1px; padding: 0px 1ex; }
table th { border: solid black 3px; backgorund: #ccc; }
</style>

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
    <p>Here is the music I've made for this year's Global Game Jam (2016), most recent first. Please see <a href="https://github.com/plaidfluff/ggj2016-music">my GitHub repo</a> for more information.</p>
<table>
<tr><th>Folder</th><th>Name</th><th>mp3</th><th>ogg</th><th>flac</th><th>Updated</th></tr>
EOF

find . -type f -name '*.mp3' | while read mp3 ; do
    printf '%d %s\n' $(stat -f %m "$mp3") "$mp3"
done | sort -nr | while read mtime mp3 ; do
    echo mtime=$mtime mp3=$mp3 1>&2
    dir="$(dirname "$mp3" | cut -f2- -d/)"
    basename="$(basename "$mp3" .mp3)"
    pathpart="$(dirname "$mp3")/$basename"
    fmtime="$(stat -t "%Y-%m-%d %H:%M" -f %Sm "$mp3")"
    printf '<tr>
    <td>%s</td>
    <td>%s</td>
    <td><a href="%s">mp3</a></td>
    <td><a href="%s.ogg">ogg</a></td>
    <td><a href="%s.flac">flac</a></td>
    <td>%s</td>
    </tr>' "$dir" "$basename" "$mp3" "$pathpart" "$pathpart" "$fmtime"
done
printf '</table>'

cat << EOF
</ul>
</body></html>
EOF
) > index.html