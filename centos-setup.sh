#!/bin/bash

yum -y update
yum -y install yum-utils
yum -y groupinstall development
yum -y install https://centos7.iuscommunity.org/ius-release.rpm
yum -y install python36u

git clone https://github.com/iamemilio/Knowledgent-Intern-Project-2017.git