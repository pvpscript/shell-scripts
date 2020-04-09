#!/bin/bash

# A marquee script for Polybar.
# It will display the current window's title and make it slide across the bar ;)

IFS='
'

DISPLAY_LEN=30
SPEED=0.2
INTERVAL=1

while true; do
        WINDOW_TITLE=$(sed -e 's/^"//' -e 's/"$//' <<< "$(xprop -id "$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)" _NET_WM_NAME 2>/dev/null | awk -F ' = ' '{$1=""; print substr($0, 2)}')")
        start_pos=0
        max_len=$(( ${#WINDOW_TITLE} - DISPLAY_LEN ))
        
        echo -n "$WINDOW_TITLE" | cut -c1-$DISPLAY_LEN && sleep $INTERVAL
        for ((i = 0; i <= max_len; i++)); do
                unset str
                for ((j = 0; j < DISPLAY_LEN; j++)); do
                        char_to_print=$(( $(( (start_pos + j) % ${#WINDOW_TITLE} )) + 1 ))
                        str=${str}$(echo -n "$WINDOW_TITLE" | cut -c$char_to_print-$char_to_print)
                done
                echo "$str"

                start_pos=$(( start_pos + 1 ))
                sleep $SPEED

                TITLE_CHECK=$(sed -e 's/^"//' -e 's/"$//' <<< "$(xprop -id "$(xprop -root 32x '\t$0' _NET_ACTIVE_WINDOW | cut -f 2)" _NET_WM_NAME 2>/dev/null | awk -F ' = ' '{$1=""; print substr($0, 2)}')")
                if [ "$WINDOW_TITLE" != "$TITLE_CHECK" ]; then
                        break
                fi
        done
        
        sleep $INTERVAL
done
