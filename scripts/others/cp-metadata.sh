#!/bin/bash

src_path="$1"
dst_path="$2"

find "$src_path" ! -path "$src_path" |
        while read src_file; do
                dst_file="$dst_path${src_file#$src_path}"
                chmod --reference="$src_file" "$dst_file"
                chown p3t3r:p3t3r "$dst_file"
                touch --reference="$src_file" "$dst_file"
        done
