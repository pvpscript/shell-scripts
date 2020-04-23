#!/bin/sh

die() {
	echo "$1"
	exit 1
}

parse_kv() {
	[ -z "$1" ] && die "Missing first argument"
	[ -z "$2" ] && die "Missing second argument"
	[ -z $(echo "$2" | sed -n '/^[0-9]\+$/p') ] && \
		die "The second argument must be a number"

	pattern=""
	fields=""
	for i in $(seq "$2");
	do
		pattern="${pattern}.*=\"\(.*\)\""
		fields="$fields\"\\$i\""
		[ $i -ne $2 ] && pattern="${pattern} \+" && fields="${fields}\\n"
	done

	pattern="s/${pattern}/${fields}/"

	echo "$1" | sed "$pattern"	
}
