#!/bin/bash
if [[ $2 != "" ]]; then
        find_args="$1 -type f"
#        echo LA: $find_args
        for i in "${@:2}"; do
                find_args=$(echo $find_args -not -path \"$i/\*\");
        done
#        echo LE: $find_args
fi
find $1 -type f > /tmp/possible_duplicated_files
#find $find_args

file_size=0
IFS=$'\n';
for i in $(cat /tmp/possible_duplicated_files); do
        file_size=$(( $file_size + 1 ));
done

i=1;
while [ $i -le $file_size ]; do
        j=$(( $i + 1 ));
        line=$(cat /tmp/possible_duplicated_files | tail +$i | head -1);
        while [ $j -le $file_size ]; do
                aux_line=$(cat /tmp/possible_duplicated_files | tail +$j | head -1);
                #echo $line" -> "$aux_line

                res=$(diff -q $line $aux_line);
                if [[ $res == "" ]]; then
                        echo found possible duplicate:
                        echo -e \\t $line
                        echo -e \\t $aux_line
                        echo
                fi

                j=$(( $j + 1 ));
        done
        i=$(( $i + 1 ));
done

#echo $file_size;
