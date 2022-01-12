#!/bin/bash

# update packages
sudo yum -update -y

# remove docker-ce in yum.repos.d/
sudo rm /etc/yum.repos.d/docker-ce.repo

# install docker
sudo yum install yum-utils amazon-linux-extras -y
sudo yum-config-manager \
    --add-repo \
    https://download.docker.com/linux/centos/docker-ce.repo

sudo amazon-linux-extras docker -y

sudo groupadd docker
sudo usermod -aG docker $USER
sudo chown "$USER":"$USER" /home/"$USER"/.docker -R
sudo chmod g+rwx "$HOME/.docker" -R

sudo systemctl enable docker.service
sudo systemctl enable containerd.service

sudo systemctl start containerd
sudo systemctl start docker

# check docker info
docker info
