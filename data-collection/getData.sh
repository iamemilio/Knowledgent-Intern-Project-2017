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

#Boston Public Schools
wget http://bostonopendata-boston.opendata.arcgis.com/datasets/1d9509a8b2fd485d9ad471ba2fdb1f90_0.csv -O raw-zone/BuildBPS.csv

#Boston Private Schools Listings
wget http://bostonopendata-boston.opendata.arcgis.com/datasets/0046426a3e4340a6b025ad52b41be70a_1.csv -O raw-zone/Private.csv

#Boston Public Schools Listings
wget http://bostonopendata-boston.opendata.arcgis.com/datasets/1d9509a8b2fd485d9ad471ba2fdb1f90_0.csv -O raw-zone/Public.csv

#Boston Property Value Assesments
wget https://data.cityofboston.gov/api/views/yv8c-t43q/rows.csv?accessType=DOWNLOAD -O raw-zone/PropVal.csv

#Boston Earnings Report
wget https://data.cityofboston.gov/api/views/4swk-wcg8/rows.csv?accessType=DOWNLOAD -O raw-zone/Earnings.csv
EOF