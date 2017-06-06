#!/bin/bash

echo "Installing Docker..."
dnf -y install dnf-plugins-core
dnf config-manager \
    --add-repo \
    https://download.docker.com/linux/fedora/docker-ce.repo
dnf config-manager --set-enabled docker-ce-edge
dnf makecache fast
dnf install docker-ce
systemctl start docker
echo "Finished Installing Docker!"
echo " "


read -p "Do you want to download Hadoop? It is very large and could take a few hours [y|n]: " hadoop
if ["$hadoop" = "y"] || ["$hadoop" = "Y"]; then
	echo "Pulling Cloudera Hadoop Docker Image..."
	docker pull cloudera/quickstart
	echo "Pulled Image!"
fi





