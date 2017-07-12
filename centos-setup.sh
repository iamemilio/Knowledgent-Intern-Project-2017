#!/bin/bash

if command -v python3 > /dev/null 2>&1; then
    echo true
else
    sudo yum install epel-release
    sudo yum install python34
    curl -O https://bootstrap.pypa.io/get-pip.py
    sudo /usr/bin/python3.4 get-pip.py
fi
