#!/usr/bin/env bash
#
# Copyright (C) 2017 TAQTIQA LLC. <http://www.taqtiqa.com>
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU Affero General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
#(at your option) any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU Affero General Public License v3
#along with this program.
#If not, see <https://www.gnu.org/licenses/agpl-3.0.en.html>.
#

# See https://unix.stackexchange.com/a/401548/251061
sudo apt-get install -qq dirmngr cgmanager cgroup-lite systemd
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 18AD5014C99EF7E3BA5F6CE950BDD3E0FC8A365E
wget https://github.com/rkt/rkt/releases/download/v1.29.0/rkt_1.29.0-1_amd64.deb >/dev/null
wget https://github.com/rkt/rkt/releases/download/v1.29.0/rkt_1.29.0-1_amd64.deb.asc
gpg --verify rkt_1.29.0-1_amd64.deb.asc
sudo dpkg -i rkt_1.29.0-1_amd64.deb
rm -f rkt_1.29.0-1_amd64.deb
rm -f rkt_1.29.0-1_amd64.deb.asc