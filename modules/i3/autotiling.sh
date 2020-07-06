#!/usr/bin/env bash

REGEX="([0-9]+)x([0-9]+)"

update_split(){
    OUTPUT="$(xdotool getwindowfocus getwindowgeometry)"

    if [[ $OUTPUT =~ $REGEX ]]
    then
        WIDTH="${BASH_REMATCH[1]}"
        HEIGHT="${BASH_REMATCH[2]}"
        if [ $WIDTH -gt $HEIGHT ]; 
        then 
            i3-msg "split h"
        else
            i3-msg "split v"
        fi
    fi
}

while read -r line 
do
    LAYOUT="$(i3-msg -t get_tree | jq -r 'recurse(.nodes[]; .nodes != null) | select(.nodes[].focused).layout')"
    if [ "$LAYOUT" = "splitv" ] || [ "$LAYOUT" = "splith" ]; then
        update_split
    fi
done < <(xprop -spy -root _NET_ACTIVE_WINDOW)
