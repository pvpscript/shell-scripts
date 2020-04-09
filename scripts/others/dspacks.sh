#!/bin/bash
# Simplified packet describer for pacman

[[ $1 == "--enter" || $1 == "-e" ]] && enter=1 || enter=0

for i in `pacman -Qq`; do
    pacman -Qi $i |
        awk '
            $1=="Name" || $1=="Version" || $1=="Description"{
                print
            }
        '; 
    echo
    if [ $enter -eq 1 ]; then
        read -s
    fi
done;
