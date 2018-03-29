#!/usr/bin/env bash
#
# Copyright (C) 2017-2018 TAQTIQA LLC. <http://www.taqtiqa.com>
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

echo "#########################################################"
echo "##"
echo "##  STARTING: $0"
echo "##"
echo "#########################################################"

set -eoux pipefail

# See https://unix.stackexchange.com/a/401548/251061
sudo apt-get install -qq dirmngr cgmanager cgroup-lite systemd expect expect-dev gdebi-core
gpg --no-default-keyring --keyring ./rkt-deb-pubkey.gpg --keyserver hkp://pool.sks-keyservers.net --recv-key 18AD5014C99EF7E3BA5F6CE950BDD3E0FC8A365E
wget -q https://github.com/rkt/rkt/releases/download/v1.29.0/rkt_1.29.0-1_amd64.deb 
wget -q https://github.com/rkt/rkt/releases/download/v1.29.0/rkt_1.29.0-1_amd64.deb.asc
gpg --no-default-keyring --keyring ./rkt-deb-pubkey.gpg --verify rkt_1.29.0-1_amd64.deb.asc
sudo -- sh -c 'DEBIAN_FRONTEND=noninteractive; gdebi --non-interactive --quiet rkt_1.29.0-1_amd64.deb'
rm -f rkt_1.29.0-1_amd64.deb
rm -f rkt_1.29.0-1_amd64.deb.asc