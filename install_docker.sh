#!/bin/bash

## Installing curl and jq

sudo yum install epel-release -y
sudo yum install curl -y
sudo yum install jq -y


## Installing docker

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh
#sudo usermod -aG docker centos
sudo rm get-docker.sh
sudo systemctl enable docker
sudo systemctl start docker

## Installing docker-compose

#sudo curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
