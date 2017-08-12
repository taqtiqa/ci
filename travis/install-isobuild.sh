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

# IMPORTANT: Your CI steps (e.g. .travis.yml) must pipe this script to bash
# (not to sh)! in the Travis CI environment.
# A #!/bin/bash shebang here won't help.

set -eoux pipefail

. /etc/lsb-release

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

#function json_value() {
#  KEY=${1-'key'}
#  POS=${2-''}
#  awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed 's/\\n/\n/g' | sed -n ${POS}p
#}

#BUILD_SLUG='containers/build' # Idiosyncratic naming prevents using $BUILD_NAME
#BUILD_NAME='acbuild'
#BUILD_BIN_DIR="/bin"
#BUILD_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/${BUILD_SLUG}/releases/latest | json_value tag_name)
#
#NAME=${BUILD_NAME:-$DEFAULT_BUILD_NAME}
#SLUG=${BUILD_SLUG:-$DEFAULT_BUILD_SLUG}
#VERSION=${BUILD_VERSION:-$DEFAULT_BUILD_VERSION}
#BIN_DIR=${BUILD_BIN_DIR:-$DEFAULT_BUILD_BIN_DIR}
#
#ARTIFACT="${NAME}-${VERSION}.tar.gz"
#ARTIFACT_URL="https://github.com/${SLUG}/releases/download/${VERSION}/${ARTIFACT}"

# System requirements

case $DISTRIB_ID in
     Ubuntu)
          echo "I know it! It is an operating system based on Debian."
          apt-get -qq update
          ;;
     Centos|RHEL)
          echo "Hey! It is my favorite Server OS!"
          ;;
     *)
          echo "Hmm, seems i've never used it."
          ;;
esac

case $DISTRIB_CODENAME in
     artful)
          echo "Install packages for (in development) ${DISTRIB_CODENAME}."
          apt-get install -t xenial-backports # Remove on angry release
          apt-get --yes install syslinux isolinux squashfs-tools genisoimage debootstrap
          ;;
     xenial|zesty)
          echo "Install packages for ${DISTRIB_CODENAME}."
          apt-get --yes install syslinux isolinux squashfs-tools genisoimage debootstrap
          ;;
     trusty)
          echo "Install packages for ${DISTRIB_CODENAME}."
          apt-get --yes install syslinux syslinux-common squashfs-tools genisoimage debootstrap
          ;;
     hardy)
          wget http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.9~hardy1_all.deb
          dpkg --install debootstrap_1.0.9~hardy1_all.deb
          ;;
     *)
          echo "Hmm, seems i've never used ${DISTRIB_CODENAME}."
          ;;
esac

#    http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.7~dapper1_all.deb - If you want a dapper chroot
#
#    http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.7~edgy1_all.deb - If you want a edgy chroot
#
#    http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.7~feisty1_all.deb - If you want a feisty chroot
#
#    http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.7~gutsy1_all.deb - If you want a gutsy chroot
#
#    http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/debootstrap_1.0.9~hardy1_all.deb - If you want a hardy chroot (if that's not available go to http://archive.ubuntu.com/ubuntu/pool/main/d/debootstrap/ and find the newest one)

#pushd /tmp
#  #git clone https://github.com/${SLUG}.git ./${NAME}
#  curl -L -o "${ARTIFACT}" "${ARTIFACT_URL}"
#  curl -L -o "${ARTIFACT}.asc" "${ARTIFACT_URL}.asc"
#  mkdir -p ./${NAME}
#  tar zxvf $ARTIFACT -C ./${NAME} --strip-components=1
#  pushd ./${NAME}
#    ls -la
#    sudo mkdir -p ${BIN_DIR}
#    sudo cp -rf acbuild acbuild-chroot acbuild-script ${BIN_DIR}/
#    #export PATH=$PATH:${BIN_DIR}
#  popd
#popd
#echo $(which acbuild)
#acbuild version
echo "Success"