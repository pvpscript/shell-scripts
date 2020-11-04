#!/bin/bash

IFS=$'\n'

tmp_pkg=$(mktemp)
trap "rm -f $tmp_pkg" EXIT

for i in $(pacman -Qq); do
	date -d $(grep "\[ALPM\] installed $i (" /var/log/pacman.log | sed 's/\[\(.*\)\] \[ALPM\].*/\1/') +"%s $i" >> "$tmp_pkg"
done

while read -r line; do
	date=$(date -d @$(echo $line | cut -d ' ' -f 1) +"%d/%m/%Y %T")
	package=$(echo $line | cut -d ' ' -f 2)

	echo $date
	pacman -Qi $package |
		awk '
		    $1=="Name" || $1=="Version" || $1=="Description" {
			print
		    }
		';
	echo
done <<< $(cat "$tmp_pkg" | sort -h)
