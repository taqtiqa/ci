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

#
# Download a file from a repository URL
#
# Usage: get-deb.sh <repo-url> <file.deb>
#
# Examples:
# travis/get-deb.sh http://mirrors.kernel.org/ubuntu/pool/main/d/debootstrap/
# and
# travis/get-deb.sh http://mirrors.kernel.org/ubuntu/pool/main/d/debootstrap/ debootstrap_1.0.59ubuntu0.8_all.deb
#
# Note:
# This is a workaround for https://github.com/travis-ci/travis-ci/issues/5221
# Whereby packages are not found.

U="$1"
FILE="$2"

if [[ $# -lt 1 ]] ; then
  echo "Usage: $0 <repo-url> [file.deb to download]"
  echo "without \"file.deb to download\" this script will list the files inside the repo"
  exit 1
fi

for i in $(curl -l "$U" 2>/dev/null|grep -i 'href='|sed -e 's/.*href=//g' -e 's/>.*//g' -e 's/"//g'|grep -v '/$'|grep "$FILE")
do
 if [[ -z "$FILE" ]]
 then
  echo "FILE: $i"
 else
  echo "Download file: $i"
  curl -q "${U}/${i}" --output "$i" 2>/dev/null
  ls -la "$i"
 fi
done