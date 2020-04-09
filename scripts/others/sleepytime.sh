#!/bin/bash

# Reproduction of the sleepyti.me for terminal use

fall_asleep_average=$((14 * 60))
cycle=$((90 * 60))
min_sleep=$(($cycle * 3))

zzz() {
    echo It takes the average human
    echo $(tput bold)fourteen minutes$(tput sgr0) to fall
    echo asleep.
    echo
    echo If you head to bed right now,
    echo you should try to wake up at
    echo one of the following times:
    echo

    for i in {1..6}; do
        period=$(( $i * $cycle + $fall_asleep_average))
        echo -\> $(date '+%H:%M' --date=@"$(( $(date '+%s') + $period ))")
    done;

    echo
    echo A good night\'s sleep consists
    echo of 5-6 complete sleep cycles
}

wake() {
    hours=()

    echo You should try $(tput bold)fall asleep$(tput sgr0) at
    echo one of the following times:
    echo

    hours[1]=$(date '+%H:%M' --date=@"$(( $(date '+%s' --date=$1) - $min_sleep ))") 
    for i in {1..3}; do
        period=$(( $i * $cycle + $min_sleep))
        hours[$(( $i + 1 ))]=$(date '+%H:%M' --date=@"$(( $(date '+%s' --date=$1) - $period ))")
    done;

    for i in {4..1}; do
        echo -\> ${hours[$i]}
    done;

    echo
    echo Please keep in mind that you
    echo should be $(tput bold)falling asleep$(tput sgr0) at
    echo these times.
}

if [ "$1" == "-zzz" ]; then
    zzz
elif [ "$1" == "-wake" ] && [ "$2" != "" ]; then
    wake $2
else
    echo Usage: -zzz \| -wake 07:00
fi
