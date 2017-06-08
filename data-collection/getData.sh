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
ssh "$path" mkdir raw-zone
scp -r offline-datasets/ createHiveTables.sh "$path":~/raw-zone
ssh "$path" sudo bash createHiveTables.sh