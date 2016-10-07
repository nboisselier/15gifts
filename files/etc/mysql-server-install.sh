#!/usr/bin/env bash
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections < /etc/debconf-set-selections.txt
apt-get install -qqy mysql-server
