#!/usr/bin/env bash

set -x

# run command
# MYSQL_PASS=? PG_PASS=? MG_ADMIN_PASS=? MG_USER_PASS=? ${REPO_PATH_ALGO}/bin/test_db_start.sh

${REPO_PATH_ALGO}/bin/test_db_mongo_start.sh
${REPO_PATH_ALGO}/bin/test_db_mysql_start.sh
${REPO_PATH_ALGO}/bin/test_db_pg_start.sh