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
ssh "$path" << EOF
mkdir raw-zone

#Mass Educator Performance Evaluations by school
scp offline-datasets/EducatorEvalPerf.csv "$path":/raw-zone/

#Mass college attendance rate by school
scp offline-datasets/Gradsattendingcollege.csv "$path":/raw-zone/

#Mass graduation rate by school
scp offline-datasets/graduates.csv "$path":/raw-zone/

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

#Mass Graduation Rates by school
wget http://profiles.doe.mass.edu/state_report/gradrates.aspx?&export_excel=yes&ctl00$ContentPlaceHolder1$cohortYear=2014&ctl00$ContentPlaceHolder1$reportType=SCHOOL&ctl00$ContentPlaceHolder1$rateType=4-Year:REG&ctl00$ContentPlaceHolder1$studentGroup=5 -O raw-zone/MassGradRates.csv

#Mass SAT averages by school
wget http://profiles.doe.mass.edu/state_report/sat_perf.aspx?ctl00$ContentPlaceHolder1$fycode=2015&export_excel=yes&ctl00$ContentPlaceHolder1$reportType=SCHOOL&ctl00$ContentPlaceHolder1$studentGroup=ALL -O raw-zone/MassAvgSAT.csv

#Mass Demographics by school
wget http://profiles.doe.mass.edu/state_report/enrollmentbyracegender.aspx?mode=school&year=2015&Continue=View+Report&export_excel=yes -O raw-zone/MassDemographics.csv
EOF
