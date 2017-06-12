#!/bin/bash
header=$(cut -d$'\n' -f 1 raw-zone/buildbps.csv)
IFS=',' read -r -a params <<< "$header"
cat <<_EOF >> idk.txt
CREATE TABLE IF NONE EXISTS '$filename' ( ${params[0]} string, ${params[1]} string, ${params[2]} numeric, ${params[3]} string, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} string, ${params[8]} numeric, ${params[9]} numeric, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} numeric,${params[15]} numeric,${params[16]} numeric,${params[17]} numeric,${params[18]} numeric,${params[19]} numeric,${params[20]} numeric,\
${params[21]} string,${params[22]} string,${params[23]} string,${params[24]} string,${params[25]} string,${params[26]} numeric,${params[27]} numeric,${params[28]} numeric,${params[29]} numeric,${params[30]} numeric,${params[31]} numeric,${params[32]} numeric,${params[33]} numeric,${params[34]} numeric,${params[35]} numeric,${params[36]} numeric,${params[37]} numeric,${params[38]} numeric,${params[39]} numeric,${params[40]} numeric,\
COMMENT ‘Location and Administrative info for Boston Public Schools’ 
ROW FORMAT DELIMITED 
FIELDS TERMINATED BY ‘,’ 
LINES TERMINATED BY ‘\n’ 
STORED AS TEXTFILE;
_EOF