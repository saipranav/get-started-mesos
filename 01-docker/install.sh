#!/bin/bash

## Installing docker
# https://docs.docker.com/engine/installation/linux/ubuntu/#install-using-the-repository

# Prerequisites
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add the docker gpg key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo apt-key fingerprint 0EBFCD88

# Add the apt repo
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get -y update

# Install docker community edition
sudo apt-get -y install docker-ce

# Docker needs root permision to run for every command. Instead we are adding ourselves to docker group
sudo usermod -aG docker `whoami`

# log out and log in to reflect the docker user group addition