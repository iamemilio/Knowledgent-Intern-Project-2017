mkdir hive-raw-zone
touch hive-raw-zone/load-data.hql

for file in $(ls raw-zone/offline-datasets/)
do
filename=$(echo "$file" | cut -d$'.' -f 1) 
tail -n +2 raw-zone/offline-datasets/$file > hive-raw-zone/$filename-stripped.csv

#parse out the headers
header=$(cut -d$'\n' -f 1 raw-zone/offline-datasets/$file)
IFS=',' read -r -a params <<< "$header"

#create hive tables for data sets
case $filename in
    "BuildBPS"*)
        "CREATE TABLE IF NONE EXISTS \'$filename\' ( {params[0]} int, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} string) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> hive-raw-zone/load-data.hql
        ;;   
    
    "Earnings"*)
        "CREATE TABLE IF NONE EXISTS \'$filename\' ( ${params[0]} string, ${params[1]} string, ${params[2]} string, ${params[3]} string, ${params[4]} int, ${params[5]} int, ${params[6]} int, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} int, ${params[11]} int, ${params[12]} int) \
        COMMENT ‘Salaries for Public Employees’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> hive-raw-zone/load-data.hql
        ;;    

    "EducatorEval"*)
        "CREATE TABLE IF NONE EXISTS \'$filename\' (  ${params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} int, ${params[5]} int, ${params[6]} int, ${params[7]} int) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> hive-raw-zone/load-data.hql
        ;;

    "Gradsattendingcollege"*)
        "CREATE TABLE IF NONE EXISTS \'$filename\' ( ${params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} int, ${params[5]} int, ${params[6]} int, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} int, ${params[11]} int) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> hive-raw-zone/load-data.hql
        ;;    

    "graduates"*)
       "CREATE TABLE IF NONE EXISTS \'$filename\' ( {params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} int, ${params[5]} int, ${params[6]} int, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} int) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> hive-raw-zone/load-data.hqls
        ;;

    "Private"*)
        "CREATE TABLE IF NONE EXISTS \'$filename\' ( {params[0]} int, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} string) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> hive-raw-zone/load-data.hql
        ;;    

    "Public"*)
        "CREATE TABLE IF NONE EXISTS \'$filename\' ( {params[0]} int, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} string) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> hive-raw-zone/load-data.hql
        ;;    
esac
"LOAD DATA INPATH \'/data/hive/$file\' INTO TABLE $filename;" >> hive-raw-zone/load-data.hql
done

#move files into hdfs
hadoop fs -mkdir data
hadoop fs -mkdir data/hive
hadoop fs -put ~/hive-raw-zone/ data/hive/

#hive -f hive-raw-zone/load-data.hql