#!/bin/bash

read -p "You must have a hadoop environment set up already to run this script! Continue? [y|n] " checkpoint0

case $checkpoint0 in
    y|Y) 
        echo "Enter your Hadoop login information" 
        ;;
    n|n|*)
        echo "Exiting"
        exit 1
        ;;
esac

read -p "User: " user
read -p "IP and Port: " IP
path="$user@$IP"
scp -r offline-datasets/ "$path":~/raw-zone
ssh "$path" << EOF
#strip file headerss
mkdir hive-raw-zone
rz="$(pwd)/raw-zone/"
echo $rz

for file in $(ls raw-zone/)
do
let filename=$(cut -d$'.' -f1 $file)
cat $file | cut -d$'\n' f2- > hive-raw-zone/$filename-stripped.csv

#move files into hdfs
hadoop fs -mkdir data
hadoop fs -mkdir data/hive
hadoop fs -put raw-zone/ data/hive

#parse out the headers
header=$($file | cut -d$'\n' -f1)
IFS=',' read -r -a params <<< "$header"

#create hive tables for data sets
case $filename in
    "BuildBPS"*)
        CREATE TABLE IF NONE EXISTS $filename ( {params[0]} int, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} string) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;
        ;;   
    
    "Earnings"*)
        CREATE TABLE IF NONE EXISTS $filename ( ${params[0]} string, ${params[1]} string, ${params[2]} string, ${params[3]} string, ${params[4]} int, ${params[5]} int, ${params[6]} int, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} int, ${params[11]} int, ${params[12]} int) \
        COMMENT ‘Salaries for Public Employees’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;
        ;;    

    "EducatorEval"*)
        CREATE TABLE IF NONE EXISTS $filename (  ${params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} int, ${params[5]} int, ${params[6]} int, ${params[7]} int) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;
        ;;

    "Gradsattendingcollege"*)
        CREATE TABLE IF NONE EXISTS $filename ( ${params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} int, ${params[5]} int, ${params[6]} int, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} int, ${params[11]} int) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;
        ;;    

    "graduates"*)
        CREATE TABLE IF NONE EXISTS $filename ( {params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} int, ${params[5]} int, ${params[6]} int, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} int) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;
        ;;

    "Private"*)
        CREATE TABLE IF NONE EXISTS $filename ( {params[0]} int, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} string) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;
        ;;    

    "Public"*)
        CREATE TABLE IF NONE EXISTS $filename ( {params[0]} int, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} string) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;
        ;;    
esac
LOAD DATA INPATH '/data/hive/$file' INTO TABLE $filename
done
EOF