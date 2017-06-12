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
scp -r boston-school-data/raw-zone/ "$path":~/
ssh "$path" bash boston-school-data/createHiveTables.sh