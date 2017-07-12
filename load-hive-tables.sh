#!/bin/bash

if [ ! -d "~/prep-raw-zone" ]; then
    cp -r automated-data-aggregation/ ~/prep-raw-zone
fi

cd ~/prep-raw-zone
read -p "Are you using an existing database? [y|n]: " mkdb
case $mkdb in
    y|Y) 
        read -p "Enter the name of the database you want to use: " database
        newDB="n"
        ;;
    n|n|*)
        read -p "Enter a name for the new database: " database
        newDB="y"
        ;;
esac

read -p "Do you want to use hive, beeline: " q2
case $q2 in
    hive|Hive|HIVE) 
        hive="-h" 
        ;;
    beeline|Beeline|BEELINE)
        hive="-b"
        read -p "Enter your beeline jdbc string: " JDBC
        ;;
    *)
        echo "That is not one of the options... Exiting!"
        exit 1
        ;;
esac

read -p "Which HDFS user do you want to store the tables in?: " user

#hadoop user ; create new db flag; database name; hive or beeline; jdbc string for beeline or hive2; use offline data flag;

IFS=$'\n' read -r -a dataSource <<< "$(cat $workspace/data-sources.csv)"
for source in "${dataSource[@]}"
do
    name="$(echo $source | cut -d$',' -f 2 )"
    addr="$(echo $source | cut -d$',' -f 3 )"
    
    #download data from url address provided iff: its not already in raw data and an address is provided
    if ! [ -r "raw-data/$name" ] || [ -z "$addr" ];then
        wget -O raw-data/"$name" "$addr"
    fi
done

mkdir prepped-raw-data
touch load-data.hql

#if make new database --> use $3 as name or use default if $3 is blank otherwise use $3 database
case $newDB in
    #case: make new database
    y)
        #default case: empty database name
        if [ -z "$database" ]; then
            database=boston_data;
            echo "CREATE DATABASE IF NOT EXISTS $database;" >> load-data.hql
        #create new database with name given in prompts above ($database)
        else
            echo "CREATE DATABASE IF NOT EXISTS $database;" >> load-data.hql
        fi ;;
    n)
        if [ -z "$database" ]; then
            database=boston_data
        fi ;;
esac

for file in $(ls raw-data)
do
    filename=$(echo "$file" | cut -d$'.' -f 1) #future --> make part of python
    sed -i '1 s/\xEF\xBB\xBF//' raw-data/$file
    tail -n +2 raw-data/$file > prepped-raw-data/$filename-stripped.csv
done

python3 -c "import createHiveScript; createHiveScript.prepData('$database', '$user')"

#move files into hdfs
hadoop fs -mkdir $database
hadoop fs -mkdir $database/data
hadoop fs -mkdir $database/data/raw-zone
hadoop fs -put prepped-raw-data/ $database/data/raw-zone
hadoop fs -mkdir $database/hive
hadoop fs -mkdir $database/hive/raw-zone
case $hive in
    -h)
        hive -f load-data.hql;;
    -b)
        beeline -u "$JDBC" -f load-data.hql;;
esac