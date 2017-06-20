#!/bin/bash

if [ -z "$1" ]; then
    echo "No user provided! Exiting!"
    exit 1
fi
mv remote-packet "$3"-data
workspace="$3"-data
if [[ -z "$6" || "$6" -eq "n" ]]; then
    mkdir "$workspace"
    mkdir "$workspace"/raw-data
    IFS=$'\n' read -r -a dataSource <<< "$(cat $workspace/data-sources.csv)"
    for source in "${dataSource[@]}"
    do
        name="$(echo $source | cut -d$',' -f 2 )"
        addr="$(echo $source | cut -d$',' -f 3 )"
        wget -O "$3"-data/raw-data/"$name" "$addr"
    done
    else
        IFS=$'\n' read -r -a dataSource <<< "$(cat $workspace/data-sources.csv)"
fi

mkdir "$workspace"/hive-ready-raw-data
touch "$workspace"/load-data.hql

#if make new database --> use $3 as name or use default if $3 is blank otherwise use $3 database
case $2 in
    "y")
        if [ -z "$3" ]; then
            echo "CREATE DATABASE IF NOT EXISTS boston_data;" >> "$workspace"/load-data.hql
            database=boston_data;
        else
            database=$3
            echo "CREATE DATABASE IF NOT EXISTS $3;" >> "$workspace"/load-data.hql
        fi ;;
    "n")
        if [ -z "$3" ]; then
            database=boston_data
        else
            database="$3"
        fi ;;
esac


for file in $(ls "$workspace"/raw-data)
do
    filename=$(echo "$file" | cut -d$'.' -f 1)
    tail -n +2 "$workspace"/raw-data/$file > "$workspace"/hive-ready-raw-data/$filename-stripped.csv
done
cd $workspace
python3 -c 'import prep-data; prep-data.prepData($database, $1)'