#!/bin/bash
mkdir boston-school-data/hive-raw-zone
touch boston-school-data/load-data.hql

echo "CREATE DATABASE IF NOT EXISTS boston_data;" >> boston-school-data/load-data.hql

for file in $(ls boston-school-data/raw-zone)
do
filename=$(echo "$file" | cut -d$'.' -f 1) 
tail -n +2 boston-school-data/raw-zone/$file > boston-school-data/hive-raw-zone/$filename-stripped.csv

#parse out the headers
header=$(cut -d$'\n' -f 1 boston-school-data/raw-zone/$file)
IFS=',' read -r -a params <<< "$header"

#modify headers to be more database friendly
for i in $(seq 1 ${#params[@]})
do
#remove all slashes
params[$i]=${params[$i]//'/'/}
#replace spaces in column headers with underscores
params[$i]=${params[$i]// /_}
#make all column headers lower case
params[$i]=${params[$i],,}

done

#create hive tables for data sets
case $filename in
    "buildbps"*)
        echo "CREATE EXTERNAL TABLE IF NOT EXISTS boston_data.$filename ( ${params[0]} string, ${params[1]} string, ${params[2]} string, ${params[3]} string, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} float, ${params[8]} float, ${params[9]} string, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} int, ${params[14]} int, ${params[15]} int, ${params[16]} float, ${params[17]} string, ${params[18]} string, ${params[19]} string, ${params[20]} string, ${params[21]} string, ${params[22]} string, ${params[23]} string, ${params[24]} string, ${params[25]} int, ${params[26]} int, ${params[27]} int, ${params[28]} int, ${params[29]} int, ${params[30]} int, ${params[31]} int, ${params[32]} int, ${params[33]} int, ${params[34]} int, ${params[35]} int, ${params[36]} int, ${params[37]} int, ${params[38]} int, ${params[39]} int, ${params[40]} int, ${params[41]} int, ${params[42]} int, ${params[43]} int, ${params[44]} string, ${params[45]} int, ${params[46]} string, ${params[47]} int , ${params[48]} string, ${params[49]} string, ${params[50]} string, \
${params[51]} string, ${params[52]} string, ${params[53]} string, ${params[54]} int, ${params[55]} int, ${params[56]} string, ${params[57]} string, ${params[58]} string, ${params[59]} string, ${params[60]} string, ${params[61]} string, ${params[62]} string, ${params[63]} string, ${params[64]} string, ${params[65]} string, ${params[66]} string, ${params[67]} string, ${params[68]} string, ${params[69]} string, ${params[70]} string, ${params[71]} string, ${params[72]} string, ${params[73]} string, ${params[74]} string, ${params[75]} string, ${params[76]} string, ${params[77]} string, ${params[78]} string, ${params[79]} string, ${params[80]} string, ${params[81]} string, ${params[82]} string, ${params[83]} string, ${params[84]} string, ${params[85]} string, ${params[86]} string, ${params[87]} string, ${params[88]} string, ${params[89]} string, ${params[90]} string, ${params[91]} string, ${params[92]} string, ${params[93]} string, ${params[94]} string, ${params[95]} string, ${params[96]} string, ${params[97]} string, ${params[98]} string, ${params[99]} string, ${params[100]} string, \
${params[101]} string, ${params[102]} string, ${params[103]} string, ${params[104]} string, ${params[105]} string, ${params[106]} string, ${params[107]} string, ${params[108]} string, ${params[109]} string, ${params[110]} string, ${params[111]} string, ${params[112]} string, ${params[113]} string, ${params[114]} string, ${params[115]} string, ${params[116]} string, ${params[117]} string, ${params[118]} string, ${params[119]} string, ${params[120]} string, ${params[121]} string, ${params[122]} string, ${params[123]} string, ${params[124]} string, ${params[125]} string, ${params[126]} string, ${params[127]} string, ${params[128]} string, ${params[129]} string, ${params[130]} string, ${params[131]} string, ${params[132]} string, ${params[133]} string, ${params[134]} string, ${params[135]} string, ${params[136]} string, ${params[137]} string, ${params[138]} string, ${params[139]} string, ${params[140]} string, ${params[141]} string, ${params[142]} string, ${params[143]} string, ${params[144]} string, ${params[145]} string, ${params[146]} string, ${params[147]} string, ${params[148]} string, ${params[149]} string, ${params[150]} string, \
${params[151]} string, ${params[152]} string, ${params[153]} string, ${params[154]} string, ${params[155]} string, ${params[156]} string, ${params[157]} string, ${params[158]} string, ${params[159]} string, ${params[160]} string, ${params[161]} string, ${params[162]} string, ${params[163]} string, ${params[164]} string, ${params[165]} string, ${params[166]} string, ${params[167]} string, ${params[168]} string, ${params[169]} string, ${params[170]} string, ${params[171]} string, ${params[172]} string, ${params[173]} string, ${params[174]} string, ${params[175]} string, ${params[176]} string, ${params[177]} string, ${params[178]} string, ${params[179]} string, ${params[180]} string, ${params[181]} string, ${params[182]} string, ${params[183]} string, ${params[184]} string, ${params[185]} string, ${params[186]} string, ${params[187]} string, ${params[188]} string, ${params[189]} string, ${params[190]} string, ${params[191]} string, ${params[192]} string, ${params[193]} string, ${params[194]} string, ${params[195]} string, ${params[196]} string, ${params[197]} string, ${params[198]} string, ${params[199]} string, ${params[200]} string, \
${params[201]} string, ${params[202]} string, ${params[203]} string, ${params[204]} string, ${params[205]} string, ${params[206]} string, ${params[207]} string, ${params[208]} string, ${params[209]} string, ${params[210]} string, ${params[211]} string, ${params[212]} string, ${params[213]} string, ${params[214]} string, ${params[215]} string, ${params[216]} string, ${params[217]} string, ${params[218]} string, ${params[219]} string, ${params[220]} string, ${params[221]} string, ${params[222]} string, ${params[223]} string, ${params[224]} string, ${params[225]} string, ${params[226]} string, ${params[227]} string, ${params[228]} string, ${params[229]} string, ${params[230]} string, ${params[231]} string, ${params[232]} string, ${params[233]} string, ${params[234]} string, ${params[235]} string, ${params[236]} string, ${params[237]} string, ${params[238]} string, ${params[239]} string, ${params[240]} string, ${params[241]} string, ${params[242]} string, ${params[243]} string, ${params[244]} string, ${params[245]} string, ${params[246]} string, ${params[247]} string, ${params[248]} string, ${params[249]} string, ${params[250]} string ) 
        COMMENT ‘Location and Administrative info for Boston Public Schools’ 
        ROW FORMAT DELIMITED 
        FIELDS TERMINATED BY ‘,’ 
        LINES TERMINATED BY ‘\n’ 
        STORED AS TEXTFILE;" >> boston-school-data/load-data.hql
        ;;

    "Employee_Earnings"*)
        echo "CREATE EXTERNAL TABLE IF NOT EXISTS boston_data.$filename ( ${params[0]} string, ${params[1]} string, ${params[2]} string, ${params[3]} string, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} string, ${params[8]} string, ${params[9]} string, ${params[10]} string, ${params[11]} int ) \
        COMMENT ‘Salaries for Public Employees’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> boston-school-data/load-data.hql
        ;;    

    "EducatorEval"*)
        echo "CREATE EXTERNAL TABLE IF NOT EXISTS boston_data.$filename ( ${params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} float, ${params[4]} float, ${params[5]} float, ${params[6]} float, ${params[7]} float, ${params[8]} float ) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> boston-school-data/load-data.hql
        ;;

    "Gradsattendingcollege"*)
        echo "CREATE EXTERNAL TABLE IF NOT EXISTS boston_data.$filename ( ${params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} int, ${params[4]} float, ${params[5]} float, ${params[6]} float, ${params[7]} float, ${params[8]} float, ${params[9]} float, ${params[10]} float, ${params[11]} float ) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> boston-school-data/load-data.hql
        ;;    

    "graduates"*)
       echo "CREATE EXTERNAL TABLE IF NOT EXISTS boston_data.$filename ( ${params[0]} string, ${params[1]} int, ${params[2]} int, ${params[3]} float, ${params[4]} float, ${params[5]} float, ${params[6]} float, ${params[7]} float, ${params[8]} float ) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> boston-school-data/load-data.hql
        ;;

    "Non_Public"*)
        echo "CREATE EXTERNAL TABLE IF NOT EXISTS boston_data.$filename ( ${params[0]} double, ${params[1]} double, ${params[2]} int, ${params[3]} int, ${params[4]} int, ${params[5]} string, ${params[6]} string, ${params[7]} string, ${params[8]} string, ${params[9]} string, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} string, ${params[15]} string ) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> boston-school-data/load-data.hql
        ;;    

    "Public"*)
        echo "CREATE EXTERNAL TABLE IF NOT EXISTS boston_data.$filename ( ${params[0]} double, ${params[1]} double, ${params[2]} int, ${params[3]} int, ${params[4]} string, ${params[5]} string, ${params[6]} string, ${params[7]} int, ${params[8]} int, ${params[9]} int, ${params[10]} string, ${params[11]} string, ${params[12]} string, ${params[13]} string, ${params[14]} string ) \
        COMMENT ‘Location and Administrative info for Boston Public Schools’ \
        ROW FORMAT DELIMITED \
        FIELDS TERMINATED BY ‘,’ \
        LINES TERMINATED BY ‘\n’ \
        STORED AS TEXTFILE;" >> boston-school-data/load-data.hql
        ;;    
esac
echo "LOAD DATA INPATH "/data/hive/hive-raw-zone/$filename-stripped.csv" INTO  TABLE $filename;" >> boston-school-data/load-data.hql
done

#move files into hdfs
hadoop fs -mkdir data
hadoop fs -mkdir data/hive
hadoop fs -put boston-school-data/hive-raw-zone/ data/hive/

hive -f boston-school-data/load-data.hql