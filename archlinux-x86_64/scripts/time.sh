#!/bin/sh

pacman --noconfirm -S ntp
ntpdate pool.ntp.org

