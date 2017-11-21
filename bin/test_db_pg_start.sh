#!/usr/bin/env bash

# postgres
# 如果本地的volume里有文件，则设置的密码无效，原来的密码有效
docker run -d -it --restart always --name test-postgres \
	-v ${DATA_PATH}/pg/data:/var/lib/postgresql/data \
	-e POSTGRES_PASSWORD=${MYSQL_PASS} \
	-e PGDATA=/var/lib/postgresql/data/pgdata  \
	-p 5432:5432 \
	postgres:latest