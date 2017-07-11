#!/bin/bash


#hadoop user ; create new db flag; databe name; hive or beeline; jdbc string for beeline or hive2; use offline data flag;
if [ -z "$1" ]; then
    echo "No user provided! Exiting!"
    exit 1
fi
user="$1"
mv remote-packet "$3"-data #remove -data in future
workspace="$3"-data
case $5 in
    n|N|no)
#       mkdir "$workspace"
        mkdir "$workspace"/raw-data
        IFS=$'\n' read -r -a dataSource <<< "$(cat $workspace/data-sources.csv)"
        for source in "${dataSource[@]}"
            do
            name="$(echo $source | cut -d$',' -f 2 )"
            addr="$(echo $source | cut -d$',' -f 3 )"
            wget -O "$3"-data/raw-data/"$name" "$addr"
        done
        ;;
    y|Y|yes)
        IFS=$'\n' read -r -a dataSource <<< "$(cat $workspace/data-sources.csv)" 
        ;;
esac

mkdir "$workspace"/hive-ready-raw-data
touch "$workspace"/load-data.hql

#if make new database --> use $3 as name or use default if $3 is blank otherwise use $3 database
case $2 in
    y)
        if [ -z "$3" ]; then
            echo "CREATE DATABASE IF NOT EXISTS boston_data;" >> "$workspace"/load-data.hql
            database=boston_data;
        else
            database=$3
            echo "CREATE DATABASE IF NOT EXISTS $3;" >> "$workspace"/load-data.hql
        fi ;;
    n)
        if [ -z "$3" ]; then
            database=boston_data
        else
            database="$3"
        fi ;;
esac


for file in $(ls "$workspace"/raw-data)
do
    filename=$(echo "$file" | cut -d$'.' -f 1) #future --> make part of python
  #  sed -i 's/[\d128-\d255]//g' $workspace/raw-data/$file
    #sed -i '1 s/\xEF\xBB\xBF//' $workspace/raw-data/$file
    tail -n +2 "$workspace"/raw-data/$file > "$workspace"/hive-ready-raw-data/$filename-stripped.csv
done
cd $workspace
python3 -c "import createHiveScript; createHiveScript.prepData('$database', '$1')"