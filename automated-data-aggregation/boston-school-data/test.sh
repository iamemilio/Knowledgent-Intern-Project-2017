#!/bin/bash
cat > idk.txt <<EOF
CREATE TABLE IF NONE EXISTS '$filename' ( ${params[0]} string, ${params[1]} string, ${params[2]} numeric, ${params[3]} string, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} string, ${params[8]} numeric, ${params[9]} numeric, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} numeric, ${params[15]} numeric, ${params[16]} numeric, ${params[17]} numeric, ${params[18]} numeric, ${params[19]} numeric, ${params[20]} numeric,${params[21]} string, ${params[22]} string, ${params[23]} string, ${params[24]} string, ${params[25]} string, ${params[26]} numeric, ${params[27]} numeric, ${params[28]} numeric, ${params[29]} numeric, ${params[30]} numeric, ${params[31]} numeric, ${params[32]} numeric, ${params[33]} numeric, ${params[34]} numeric, ${params[35]} numeric, ${params[36]} numeric, ${params[37]} numeric, ${params[38]} numeric, ${params[39]} numeric, ${params[40]} numeric,${params[41]} numeric, ${params[42]} numeric, ${params[43]} numeric, ${params[44]} numeric, ${params[45]} numeric, ${params[46]} numeric, ${params[47]} numeric, ${params[48]} numeric, ${params[49]} numeric, ${params[50]} numeric, ${params[51]} string, ${params[52]} string, ${params[53]} date, ${params[54]} string, ${params[55]} numeric, ${params[56]} numeric, ${params[57]} string, ${params[58} string, ${params[59]} string, ${params[60]} string
EOF