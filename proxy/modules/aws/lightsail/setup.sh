#!/bin/bash

# remove docker-ce in yum.repos.d/
sudo rm -f /etc/yum.repos.d/docker-ce.repo
sudo yum update -y

# install docker
sudo yum install yum-utils amazon-linux-extras -y
sudo amazon-linux-extras install docker -y

sudo groupadd docker
sudo usermod -aG docker $USER

sudo systemctl enable docker
sudo systemctl enable containerd
sudo systemctl start containerd
sudo systemctl status containerd
sudo systemctl start docker
sudo systemctl status docker
