#!/usr/bin/env bash
#
# Copyright (C) 2018 TAQTIQA LLC. <http://www.taqtiqa.com>
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

set -eoux pipefail

## Travis-CI install of awscli via pip does not
## result in aws being added to the PATH...
pip install --user awscli
export PATH=~/.local/bin:$PATH

source /etc/lsb-release

# REQUIRED environment variables:
# DEPLOY_BUCKET = your bucket name
# AWS_ACCESS_KEY_ID = AWS access ID
# AWS_SECRET_ACCESS_KEY = AWS secret

# OPTIONAL environment variables:
# DEPLOY_BUCKET_PREFIX = a directory prefix within your bucket
# DEPLOY_BRANCHES = regex of branches to deploy; leave blank for all
# DEPLOY_EXTENSIONS = whitespace-separated file exentions to deploy; leave blank for "jar war zip"
# DEPLOY_FILES = whitespace-separated files to deploy; leave blank for $TRAVIS_BUILD_DIR/target/*.$extensions
# AWS_SESSION_TOKEN = optional AWS session token for temp keys
# PURGE_OLDER_THAN_DAYS = Files in the .../deploy and .../pull-request prefixes in S3 older than this number of days will be deleted; leave blank for 90, 0 to disable.

if [[ -z "${DEPLOY_BUCKET}" ]]
then
    echo "Bucket not specified via \$DEPLOY_BUCKET"
fi
if [[ -z "${AWS_ACCESS_KEY_ID}" ]]
then
    echo "AWS access key ID not specified via \$AWS_ACCESS_KEY_ID"
fi
if [[ -z "${AWS_SECRET_ACCESS_KEY}" ]]
then
    echo "AWS secret access key not specified via \$AWS_SECRET_ACCESS_KEY"
fi

DEFAULT_BUCKET_PATH=aci
DEFAULT_BRANCHES=master
DEFAULT_EXTENSIONS="aci asc enc"
DEFAULT_BUILD_DIR=$TRAVIS_BUILD_DIR
DEFAULT_SOURCE_DIR=deploy
DEFAULT_PURGE_OLDER_THAN_DAYS="90"

DEPLOY_BUCKET_PATH=${DEPLOY_BUCKET_PATH:-$DEFAULT_BUCKET_PATH}
DEPLOY_BRANCHES=${DEPLOY_BRANCHES:-$DEFAULT_BRANCHES}
DEPLOY_EXTENSIONS=${DEPLOY_EXTENSIONS:-$DEFAULT_EXTENSIONS}
DEPLOY_SOURCE_DIR=${DEPLOY_SOURCE_DIR:-$DEFAULT_SOURCE_DIR}
PURGE_OLDER_THAN_DAYS=${PURGE_OLDER_THAN_DAYS:-$DEFAULT_PURGE_OLDER_THAN_DAYS}

pushd ${DEPLOY_SOURCE_DIR}
    discovered_files=""
    for ext in ${DEPLOY_EXTENSIONS}
    do
        discovered_files+=" $(ls ./*.${ext} 2>/dev/null || true)"
    done
popd

files=${DEPLOY_FILES:-$discovered_files}

if [[ -z "$files" ]]
then
    echo "Files not found; not deploying."
    exit 1
fi

###########################################################
##
## Deploy & Purge
##
###########################################################

pushd ${DEPLOY_SOURCE_DIR}
    for file in $files
    do
        aws s3 cp $file s3://$DEPLOY_BUCKET/$DEPLOY_BUCKET_PATH/
    done
popd

if [[ $PURGE_OLDER_THAN_DAYS -ge 1 ]]
then
    echo "Cleaning up builds in S3 older than $PURGE_OLDER_THAN_DAYS days . . ."

    cleanup_prefix=${DEPLOY_BUCKET_PATH}
    older_than_ts=`date -d"-${PURGE_OLDER_THAN_DAYS} days" +%s`

    #for suffix in deploy pull-request
    #do
        aws s3api list-objects --bucket $DEPLOY_BUCKET --prefix $cleanup_prefix/ --output=text | \
        while read -r line
        do
            last_modified=`echo "$line" | awk -F'\t' '{print $4}'`
            if [[ -z $last_modified ]]
            then
                continue
            fi
            last_modified_ts=`date -d"$last_modified" +%s`
            filename=`echo "$line" | awk -F'\t' '{print $3}'`
            if [[ $last_modified_ts -lt $older_than_ts ]]
            then
                if [[ $filename != "" ]]
                then
                    echo "s3://$DEPLOY_BUCKET/$filename is older than $PURGE_OLDER_THAN_DAYS days ($last_modified). Deleting."
                    aws s3 rm s3://$DEPLOY_BUCKET/$filename
                fi
            fi
        done
    #done
fi
