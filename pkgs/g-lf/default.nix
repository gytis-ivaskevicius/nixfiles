{ config, pkgs, ... }:
let
  image = pkgs.writeScript "image" ''
    #!/usr/bin/env bash
    readonly ID_PREVIEW="preview"
    case "$1" in
        "clear") declare -p -A cmd=([action]=remove [identifier]="$ID_PREVIEW") > "$FIFO_UEBERZUG" ;;
        "draw")  declare -p -A cmd=([action]=add    [identifier]="$ID_PREVIEW" [x]="$3" [y]="$4" [max_width]="$5" [max_height]="$6" [path]="$2") > "$FIFO_UEBERZUG" ;;
        "*") echo "Unknown command: '$1', '$2'" ;;
    esac
  '';

  previewer = pkgs.writeScript "peviewer" ''
    #!/bin/sh

    # Calculate where the image should be placed on the screen.
    num=$(printf "%0.f\n" "`echo "$(tput cols) / 2" | bc`")
    numb=$(printf "%0.f\n" "`echo "$(tput cols) - $num - 1" | bc`")
    numc=$(printf "%0.f\n" "`echo "$(tput lines) - 2" | bc`")

    # Clear the last preview (if any) and print file information
    ${image} clear
    ${pkgs.pistol}/bin/pistol "$1"

    case "$1" in
        *.pdf)
            CACHE=$(mktemp /tmp/thumbcache.XXXXX)
            pdftoppm -png -f 1 -singlefile "$1" "$CACHE"
            ${image} draw "$CACHE.png" $num 1 $numb $numc
            ;;
        *.epub)
            CACHE=$(mktemp /tmp/thumbcache.XXXXX)
            epub-thumbnailer "$1" "$CACHE" 1024
            ${image} draw "$CACHE" $num 1 $numb $numc
            ;;
        *.bmp|*.jpg|*.jpeg|*.png|*.xpm)
            ${image} draw "$1" $num 1 $numb $numc
            ;;
        *.wav|*.mp3|*.flac|*.m4a|*.wma|*.ape|*.ac3|*.og[agx]|*.spx|*.opus|*.as[fx]|*.flac) exiftool "$1";;
        *.avi|*.mp4|*.wmv|*.dat|*.3gp|*.ogv|*.mkv|*.mpg|*.mpeg|*.vob|*.fl[icv]|*.m2v|*.mov|*.webm|*.ts|*.mts|*.m4v|*.r[am]|*.qt|*.divx)
            CACHE=$(mktemp /tmp/thumbcache.XXXXX)
            ffmpegthumbnailer -i "$1" -o "$CACHE" -s 0
            ${image} draw "$CACHE" $num 1 $numb $numc
            ;;
    esac
  '';

  lfrc = pkgs.writeTextDir "lf/lfrc" ''
    set shell sh
    set shellopts '-eu'
    set previewer ${previewer}
    set icons
    set scrolloff 10

    #map - $/etc/nixos/modules/lf/draw.sh $f

    cmd clear ''${{
      ${image} clear
    }}

    cmd open ''${{
      case $(file --mime-type $f -b) in
          text/*) $EDITOR $fx;;
          *) for f in $fx; do setsid $OPENER $f > /dev/null 2> /dev/null & done;;
      esac
    }}

    cmd delete ''${{
      set -f
      printf "$fx\n"
      printf "delete?[y/n]"
      read ans
      [ $ans = "y" ] && rm -rf $fx
    }}

    map <delete> delete
    map <bs2> delete
    map <bs> delete

    cmd extract %atool -x "$f"

    cmd tar ''${{
      set -f
      mkdir $1
      cp -r $fx $1
      tar czf $1.tar.gz $1
      rm -rf $1
    }}

    cmd zip ''${{
      set -f
      mkdir $1
      cp -r $fx $1
      zip -r $1.zip $1
      rm -rf $1
    }}

    %{{
      w=$(tput cols)
      if [ $w -le 80 ]; then
        lf -remote "send $id set ratios 1:2"
      elif [ $w -le 160 ]; then
        lf -remote "send $id set ratios 1:2:3"
      fi
    }}
  '';

  wrapped = pkgs.writeScriptBin "lf" ''
    #!/usr/bin/env bash
    export FIFO_UEBERZUG="/tmp/lf-ueberzug-''${PPID}"

    function cleanup {
      rm "$FIFO_UEBERZUG" 2>/dev/null
      pkill -P $$
    }

    mkfifo "$FIFO_UEBERZUG"
    trap cleanup EXIT
    tail --follow "$FIFO_UEBERZUG" | ${pkgs.ueberzug}/bin/ueberzug layer --silent --parser bash &

    XDG_CONFIG_HOME=${lfrc} ${pkgs.lf}/bin/lf $@
  '';

in
pkgs.symlinkJoin {
  name = "lf";
  paths = [
    wrapped
    pkgs.lf
  ];
}

#  {
#  environment.systemPackages = with pkgs; [
#    atool
#    bat
#    bc
#    ffmpegthumbnailer
#    imagemagick
#    g-pistol
#    poppler
#    ueberzug
#    lf
#    zip
##   pkgs.epub-thumbnailer
#  ];
#}
