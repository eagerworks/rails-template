#!/bin/bash

# Update and install necessary packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y docker.io curl git

# Add the user to the docker group
sudo usermod -aG docker ubuntu
