#!/bin/bash

read -p "Do you have a database that you want to use? [y|n]: " mkdb
case $mkdb in
    y|Y) 
        read -p "Enter the name of the database you want to use: " database
        newDB="n"
        ;;
    n|n|*)
        read -p "Enter a name for a database that this script will create: " database
        newDB="y"
        ;;
esac

read -p "Do you want to use Hive or Beeline: " q2
case $q2 in
    hive|Hive|HIVE) 
        hive="-h" 
        ;;
    beeline|Beeline|BEELINE)
        hive="-b"
        read -p "Enter the jdbc string for your beeline server address: " beelineJDBC
        ;;
    *)
        echo "That is not one of the options... Exiting!"
        exit 1
        ;;
esac

echo "Enter your hadoop login info below."
read -p "User: " user
read -p "IP and Port: " IP
path="$user@$IP"
scp -r boston-school-data "$path":~/
ssh "$path" bash boston-school-data/createHiveTables.sh $user $newDB $database $hive $beelineJDBC