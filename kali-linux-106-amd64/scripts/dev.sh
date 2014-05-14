#!/bin/sh

# Install and set up VirtualBox Guest Additions
export DEBIAN_FRONTEND=noninteractive
apt-get install -y linux-headers-$(uname -r)
unset DEBIAN_FRONTEND

