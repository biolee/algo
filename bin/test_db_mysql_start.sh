#!/usr/bin/env bash

# mysql
docker run -d -it --restart always  --name test-mysql \
	-v ${DATA_PATH}/mysql/data:/var/lib/mysql \
	-v ${DATA_PATH}/mysql/conf:/etc/mysql/conf.d \
	-p 3306:3306 \
	-e MYSQL_ROOT_PASSWORD=${PG_PASS} \
	mysql:latest