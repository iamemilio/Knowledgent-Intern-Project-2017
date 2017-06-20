#!/bin/bash

if [ -z "$1" ]; then
    echo "No user provided! Exiting!"
    exit 1
fi
    mv remote-packet "$3"-data
if [[ -z "$6" || "$6" -eq "n" ]]; then
    mkdir "$3"-data
    mkdir "$3"-data/raw-data
    IFS=$'\n' read -r -a dataSource <<< "$(cat data-sources.csv)"
    for source in "${dataSource[@]}"
    do
        name="$(cut -d$'\t' -f 2 $source)"
        addr="$(cut -d$'\t' -f 3 $source)"
        wget -O "$name" "$addr"
    else
        IFS=$'\n' read -r -a dataSource <<< "$(cat data-sources.csv)"
fi

mkdir "$3"-data/hive-ready-raw-data
touch "$3"-data/load-data.hql

#if make new database --> use $3 as name or use default if $3 is blank otherwise use $3 database
case $2 in
    "y")
        if [ -z "$3" ]; then
            echo "CREATE DATABASE IF NOT EXISTS boston_data;" >> "$3"-data/load-data.hql
            database=boston_data;
        else
            database=$3
            echo "CREATE DATABASE IF NOT EXISTS $3;" >> "$3"-data/load-data.hql
        fi ;;
    "n")
        if [ -z "$3" ]; then
            database=boston_data;
        else
            database=$3
        fi ;;
esac


for file in $(ls "$3"-data/raw-data)
do
filename=$(echo "$file" | cut -d$'.' -f 1)
#awk 'NR==1{sub(/^\xef\xbb\xbf/,"")}1' $file > $file
tail -n +2 "$3"-data/raw-data/$file > "$3"-data/hive-ready-raw-data/$filename-stripped.csv

python3 -c 'import prep-data; prepData($database, $1)'