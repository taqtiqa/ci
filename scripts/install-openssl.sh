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

echo "#########################################################"
echo "##"
echo "##  STARTING: $0"
echo "##"
echo "#########################################################"

set -eoux pipefail

OPENSSL_VER='1.1.0f'
OPENSSL_KEY='0E604491'
pushd /tmp
  TMP_SSL_HOME=$( mktemp -d -t 'XXXX' )
  chmod 600 $TMP_SSL_HOME/*
  chmod 700 $TMP_SSL_HOME
  curl -o openssl-${OPENSSL_VER}.tar.gz https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz
  curl -o openssl-${OPENSSL_VER}.tar.gz.asc https://www.openssl.org/source/openssl-${OPENSSL_VER}.tar.gz.asc
  curl -o openssl-security.asc https://www.openssl.org/news/openssl-security.asc
  gpg --no-tty --no-default-keyring --trust-model always --homedir ${TMP_SSL_HOME} --keyserver hkp://keyserver.ubuntu.com:80 --recv-key ${OPENSSL_KEY}
  gpg --no-tty --trust-model always --homedir ${TMP_SSL_HOME} --verify openssl-${OPENSSL_VER}.tar.gz.asc
  tar -xzf openssl-${OPENSSL_VER}.tar.gz
  pushd openssl-${OPENSSL_VER}
    ./config no-afalgeng -Wl,--enable-new-dtags,-rpath,'$(LIBRPATH)' >/dev/null
    sudo make > /dev/null
    sudo make install > /dev/null
  popd
  rm -rf openssl-${OPENSSL_VER}
  rm -rf ${TMP_SSL_HOME}
popd