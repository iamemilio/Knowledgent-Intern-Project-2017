#!/bin/bash

read -p "If Hadoop isnt running on your system, would you like to start running it? [y|n]: " hdp
case $hdp in  
    y|Y) docker run --hostname=quickstart.cloudera --privileged=true -t -i -p 8888:8888 -p 8000:8000 -p 8080:8080  cloudera/quickstart /usr/bin/docker-quickstart ;;
    n|N) ;; 
    *) ;; 
esac

let containerID = docker ps | grep cloudera/quickstart | cut -d' ' -f1
docker exec "$containerID" mkdir loadingZone
docker exec "$containerID" wget http://bostonopendata-boston.opendata.arcgis.com/datasets/1d9509a8b2fd485d9ad471ba2fdb1f90_0.csv -O loadingZone/BuildBPS.csv
docker exec "$containerID" wget http://bostonopendata-boston.opendata.arcgis.com/datasets/0046426a3e4340a6b025ad52b41be70a_1.csv -O loadingZone/Private.csv
docker exec "$containerID" wget http://bostonopendata-boston.opendata.arcgis.com/datasets/1d9509a8b2fd485d9ad471ba2fdb1f90_0.csv -O loadingZone/Public.csv
docker exec "$containerID" wget https://data.cityofboston.gov/api/views/yv8c-t43q/rows.csv?accessType=DOWNLOAD -O loadingZone/PropVal.csv

