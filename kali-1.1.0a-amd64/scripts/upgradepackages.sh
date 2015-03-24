#!/bin/sh

# Update repositories and upgrade packages
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get upgrade -y
unset DEBIAN_FRONTEND

