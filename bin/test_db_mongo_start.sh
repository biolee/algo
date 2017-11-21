#!/usr/bin/env bash

# mongodb
## ${REPO_PATH_ALGO}/src/docker/mongodb/build.sh
# MG_ADMIN_PASS
docker run -d -it --restart always --name test-mongo \
	-v ${DATA_PATH}/mongo/data:/data/db \
	-e MONGODB_ADMIN_USER=admin \
	-e MONGODB_ADMIN_PASS=${MG_ADMIN_PASS} \
	-e MONGODB_APPLICATION_DATABASE=mytestdatabase \
	-e MONGODB_APPLICATION_USER=testuser \
	-e MONGODB_APPLICATION_PASS=${MG_USER_PASS} \
	-p 27017:27017 \
	biolee/mongo:3.4