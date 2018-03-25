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

# IMPORTANT: Your .travis.yml must pipe this script to bash (not to sh)!
# In the Travis CI environment a #!/bin/bash shebang here won't help.

echo "#########################################################"
echo "##"
echo "##  STARTING: $0"
echo "##"
echo "#########################################################"

set -eoux pipefail

source /etc/lsb-release

if [ "$EUID" -ne 0 ]; then
    echo "This script uses functionality which requires root privileges"
    exit 1
fi

function json_value() {
  KEY=${1-'key'}
  POS=${2-''}
  awk -F"[,:}]" '{for(i=1;i<=NF;i++){if($i~/'$KEY'\042/){print $(i+1)}}}' | tr -d '"' | sed 's/\\n/\n/g' | sed -n ${POS}p
}

BUILD_SLUG='projectatomic/buildah' # Idiosyncratic naming prevents using $BUILD_NAME
BUILD_NAME='buildah'
BUILD_BIN_DIR="/bin"
BUILD_VERSION=$(curl -L -s -H 'Accept: application/json' https://github.com/${BUILD_SLUG}/releases/latest | json_value tag_name)

NAME=${BUILD_NAME:-$DEFAULT_BUILD_NAME}
SLUG=${BUILD_SLUG:-$DEFAULT_BUILD_SLUG}
VERSION=${BUILD_VERSION:-$DEFAULT_BUILD_VERSION}
BIN_DIR=${BUILD_BIN_DIR:-$DEFAULT_BUILD_BIN_DIR}

#ARTIFACT="${NAME}-${VERSION}.tar.gz"
ARTIFACT="${VERSION}.tar.gz"
ARTIFACT_URL="https://github.com/${SLUG}/archive/${ARTIFACT}"

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
     trusty)
          echo "Install packages for ${DISTRIB_CODENAME}."
          # apt-get -y install golang-go systemd debootstrap schroot
          apt-get -y install software-properties-common
          add-apt-repository -y ppa:alexlarsson/flatpak
          add-apt-repository -y ppa:gophers/archive
          apt-add-repository -y ppa:projectatomic/ppa
          apt-get -y -qq update
          apt-get -y install bats btrfs-tools git libapparmor-dev libdevmapper-dev libglib2.0-dev libgpgme11-dev libostree-dev libseccomp-dev libselinux1-dev skopeo-containers go-md2man
          apt-get -y install golang-1.8
          apt -y autoremove
          ;;
     xenial)
          echo "Install packages for ${DISTRIB_CODENAME}."
          # apt-get -y install golang-go debootstrap systemd-container schroot
          apt-get -y install software-properties-common
          add-apt-repository -y ppa:alexlarsson/flatpak
          add-apt-repository -y ppa:gophers/archive
          apt-add-repository -y ppa:projectatomic/ppa
          apt-get -y -qq update
          apt-get -y install bats btrfs-tools git libapparmor-dev libdevmapper-dev libglib2.0-dev libgpgme11-dev libostree-dev libseccomp-dev libselinux1-dev skopeo-containers go-md2man
          apt-get -y install golang-1.8
          apt -y autoremove
          ;;
     *)
          echo "Hmm, seems i've never used ${DISTRIB_CODENAME}."
          ;;
esac

pushd /tmp
  #git clone https://github.com/${SLUG}.git ./${NAME}
  # curl --location -o "${ARTIFACT}" "${ARTIFACT_URL}"
  # curl --location -o "${ARTIFACT}.asc" "${ARTIFACT_URL}.asc"
  # mkdir -p ./${NAME}
  # tar zxvf $ARTIFACT -C ./${NAME} --strip-components=1
  # pushd ./${NAME}
    ls -la
    export GOPATH=`pwd`
    # sudo mkdir -p ${BIN_DIR}
    git clone https://github.com/projectatomic/buildah ./src/github.com/projectatomic/buildah
    pushd ./src/github.com/projectatomic/buildah
      PATH=/usr/lib/go-1.8/bin:$PATH 
      make runc all TAGS="apparmor seccomp"
      sudo make install install.runc
      buildah --help
    popd
    #sudo cp -rf acbuild acbuild-chroot acbuild-script ${BIN_DIR}/
    #export PATH=$PATH:${BIN_DIR}
  # popd
popd
echo $(which buildah)
buildah version

# Install docker2aci that handles buildah OCI images
# See https://github.com/appc/docker2aci/issues/257

pushd /tmp
  git clone git://github.com/woofwoofinc/docker2aci
  pushd docker2aci
    ./build.sh
  popd
popd

actool --debug validate ubuntu-latest.aci

echo "Success"