#!/bin/bash

IFS=$'\n';
count=0;
for i in $(pgrep mocp); do
        count=$((count+1));
done;
if [ $count -ge 3 ]; then
        for i in "$@"; do
                mocp -a $i;
        done;
#elif pgrep mocp &>/dev/null 2>&1; then
elif [ $count -eq 2 ]; then
        for i in "$@"; do
                mocp -a $i;
        done;
        urxvt -e mocp &
else
        urxvt -e mocp "$@" &
        #for i in "$@"; do
        #        mocp -a $i;
        #done;
fi;
#else
#       # for i in "$@"; do
#       #         urxvt -e mocp $i;
#       # done;
#        urxvt -e mocp "$*";
#fi;
