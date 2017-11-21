#!/usr/bin/env bash

set -x

domain=$1

docker run -d --restart always --name gitlab \
    --hostname gitlab.example.com \
    -v ${DATA_PATH}/jenkins/data:/var/opt/gitlab \
    -v ${DATA_PATH}/jenkins/conf:/etc/gitlab \
    -v ${DATA_PATH}/jenkins/conf:/var/log/gitlab \
     -e GITLAB_OMNIBUS_CONFIG="external_url 'http://my.domain.com/'; gitlab_rails['lfs_enabled'] = true;" \
    --p 80:80 \
    --p 443:443 \
    --p 10022:22 \
    gitlab/gitlab-ce:latest
