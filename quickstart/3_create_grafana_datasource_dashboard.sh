#!/bin/bash
#set -x
# run this AFTER the Kafka cluster is up AND the Monitoring cluster is up
# 
# Expect to be running default Basic Auth for quick start
# See https://grafana.com/docs/grafana/latest/http_api/auth/
GRAFANA_API_URL="http://admin:admin@localhost:3000/api"

# See https://grafana.com/docs/grafana/latest/http_api/data_source/
printf "\n********** Creating InfluxDB datasource in Grafana **********************\n"
curl -s -X POST "$GRAFANA_API_URL/datasources" \
--header 'Content-Type: application/json' \
--data "@grafana_influxdb_datasource.json"

# See https://grafana.com/docs/grafana/latest/http_api/dashboard/
printf "\n********** Creating InfluxDB datasource in Grafana **********************\n"
curl -s -X POST "$GRAFANA_API_URL/dashboards/db" \
--header 'Content-Type: application/json' \
--data "@simple-Grafana-dashboard.json"

printf "\n\n********** Done **********************\n"
