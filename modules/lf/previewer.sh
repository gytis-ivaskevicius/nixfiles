#!/bin/sh

# Calculate where the image should be placed on the screen.
num=$(printf "%0.f\n" "`echo "$(tput cols) / 2" | bc`")
numb=$(printf "%0.f\n" "`echo "$(tput cols) - $num - 1" | bc`")
numc=$(printf "%0.f\n" "`echo "$(tput lines) - 2" | bc`")

# Clear the last preview (if any)
/etc/lf/image.sh clear

# Print file information
pistol "$1"

case "$1" in
    *.pdf)
        CACHE=$(mktemp /tmp/thumbcache.XXXXX)
        pdftoppm -png -f 1 -singlefile "$1" "$CACHE"
        /etc/lf/image.sh draw "$CACHE.png" $num 1 $numb $numc
        ;;
    *.epub)
        CACHE=$(mktemp /tmp/thumbcache.XXXXX)
        epub-thumbnailer "$1" "$CACHE" 1024
        /etc/lf/image.sh draw "$CACHE" $num 1 $numb $numc
        ;;
    *.bmp|*.jpg|*.jpeg|*.png|*.xpm)
        /etc/lf/image.sh draw "$1" $num 1 $numb $numc
        ;;
    *.wav|*.mp3|*.flac|*.m4a|*.wma|*.ape|*.ac3|*.og[agx]|*.spx|*.opus|*.as[fx]|*.flac) exiftool "$1";;
    *.avi|*.mp4|*.wmv|*.dat|*.3gp|*.ogv|*.mkv|*.mpg|*.mpeg|*.vob|*.fl[icv]|*.m2v|*.mov|*.webm|*.ts|*.mts|*.m4v|*.r[am]|*.qt|*.divx)
        CACHE=$(mktemp /tmp/thumbcache.XXXXX)
        ffmpegthumbnailer -i "$1" -o "$CACHE" -s 0
        /etc/lf/image.sh draw "$CACHE" $num 1 $numb $numc
        ;;
esac

