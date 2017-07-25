Automated Data Aggregation Tool
This tool is designed to unpack included datasets and send them to a remote hadoop edge node, 
where the data will be put into distinct raw zones and prepared to make it Hive ready. 
The final datasets will be put into a HDFS raw zone, and from there will be coppied into Hive tables.

Note! This was tested on a Fedora 25 server linux environment and was developed for Cloudera Hadoop. It may not work on other platforms.

In order to use this software, you will need to clone this entire repo in a linux environment. You will also need
access to a hadoop cluster or virtual machine.

Run this like any other bash script. No special privlages are needed. 
For those unfamiliar with bash, use the command:
bash getdata.sh

The console will prompt you on whether or not you have access to a hadoop environment, entering anything other than y will
exit the program. You will then be asked to enter your login info for the hadoop envrionment you need to access, such as your
username, the ip address of a node you have privlages for, and your password. Failure to enter this information correctly could
result in a hang up, or the program exiting. After this, it will do everything itself.