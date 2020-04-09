#!/bin/bash

IFS='= ';
read -ra args <<< "$@"

if [ -z $args ]; then
        echo No arguments given. Exiting...
        exit 1
fi

interval=2
choice=0
count=0
speed=0.5
len=20
show_labels=false

check_change()
{
        case $1 in
                artist)
                        if [ "$2" != "$(mocp -Q %artist)" ]; then
                                return 0
                        fi
                        ;;
                song)
                        if [ "$2" != "$(mocp -Q %song)" ]; then
                                return 0
                        fi
                        ;;
                album)
                        if [ "$2" != "$(mocp -Q %album)" ]; then
                                return 0
                        fi
                        ;;
        esac

        return 1
}

marquee()
{        
        start_pos=0
        input=$($show_labels && echo "$4""$1" || echo "$1")

        max_len=$(( ${#input} - $len ))

        printf "$input" | cut -z -c1-$len && printf "\n" && sleep $2

        for ((i = 0; i <= $max_len; i++)); do
                unset str
                for ((j = 0; j < $len; j++)); do
                        char_to_print=$(( $(( ($start_pos + j) % ${#input} )) + 1 ))
                        str=${str}$(printf "$input" | cut -c$char_to_print-$char_to_print)
                done
                check_change "$3" "$1" && return 1 || echo "$str"

                start_pos=$(( $start_pos + 1 ))
                sleep $speed
        done

        sleep $2 && ([[ "$5" == "0" ]] && printf "\n") && (check_change "$3" "$1" && return 1 || return 0)

}

while [ "x${args[count]}" != "x" ]; do
        case ${args[count]} in
                --len)
                        len=${args[count+1]}
                        count=$(( $count + 1 ))
                        ;;
                --interval)
                        interval=${args[count+1]}
                        count=$(( $count + 1 ))
                        ;;
                --speed)
                        speed=${args[count+1]}
                        count=$(( $count + 1 ))
                        ;;
                --show-labels)
                        show_labels=true
                        ;;
                --artist)
                        choice=1
                        ;;
                --song)
                        choice=2
                        ;;
                --album)
                        choice=3
                        ;;
                --all)
                        choice=0
                        ;;
        esac
        count=$(( $count + 1 ))
done;

while [ "$(mocp -Q %state)" != "STOP" ]; do
        case $choice in
                0)
                        if $show_labels; then
                                marquee "$(mocp -Q %artist)" $interval artist "Artist: " $choice && \
                                marquee "$(mocp -Q %song)" $interval song "Song: " $choice && \
                                marquee "$(mocp -Q %album)" $interval album "Album: " $choice
                        else
                                marquee "$(mocp -Q %artist)" $interval $choice && \
                                marquee "$(mocp -Q %song)" $interval $choice && \
                                marquee "$(mocp -Q %album)" $interval $choice
                        fi
                        ;;
                1)
                        if $show_labels; then
                                marquee "$(mocp -Q %artist)" $interval artist "Artist: " $choice
                        else
                                marquee "$(mocp -Q %artist)" $interval $choice
                        fi
                        ;;
                2)
                        if $show_labels; then
                                marquee "$(mocp -Q %song)" $interval song "Song: " $choice
                        else
                                marquee "$(mocp -Q %song)" $interval $choice
                        fi
                        ;;
                3)
                        if $show_labels; then
                                marquee "$(mocp -Q %album)" $interval album "Album: " $choice
                        else
                                marquee "$(mocp -Q %album)" $interval $choice
                        fi
                        ;;
        esac
done
