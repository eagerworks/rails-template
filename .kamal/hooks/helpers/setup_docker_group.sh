#!/bin/sh

set -e

USER_NAME=ubuntu

if groups "$USER_NAME" | grep -q "\bdocker\b"; then
    echo "User '$USER_NAME' is already in the docker group."
else
    echo "User '$USER_NAME' is not in the docker group. Adding..."

    sudo usermod -aG docker "$USER_NAME"

    echo "User '$USER_NAME' has been added to the docker group."
fi
