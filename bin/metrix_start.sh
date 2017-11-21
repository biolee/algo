#!/usr/bin/env bash

docker run -it -d --restart always --name test-prome \
		-v ${DATA_PATH}/prome/conf/prometheus.yml:/etc/prometheus/prometheus.yml \
		-p 9090:9090 \
       prom/prometheus

docker run -it -d --restart always --name test-grafana \
        -v ${DATA_PATH}/grafana/data:/var/lib/grafana \
        -v ${DATA_PATH}/grafana/conf:/etc/grafana/ \
        -e "GF_SECURITY_ADMIN_PASSWORD=${GR_PASS}" \
        -e "GF_INSTALL_PLUGINS=grafana-clock-panel,grafana-simple-json-datasource" \
		-p 3000:3000 \
        grafana/grafana