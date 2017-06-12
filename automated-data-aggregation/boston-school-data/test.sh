#!/bin/bash
cat <<EOF >> idk.txt
CREATE TABLE IF NONE EXISTS \'$filename\' ( ${params[0]} string, ${params[1]} string, ${params[2]} numeric, ${params[3]} string, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} string, ${params[8]} numeric, ${params[9]} numeric, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} numeric,${params[15]} numeric,${params[16]} numeric,${params[17]} numeric,${params[18]} numeric,${params[19]} numeric,${params[20]} numeric,\

EOF