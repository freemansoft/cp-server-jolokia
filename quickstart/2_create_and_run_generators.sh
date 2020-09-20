#!/bin/bash
# run this AFTER the Kafka cluster is up AND the Monitoring cluster is up
# 
# This creates uses the sample data generator to create traffic
DATAGEN_URL="localhost:8083"

printf "\n********** Creating datagen pageviews **********************\n"
curl -s -X POST "http://$DATAGEN_URL/connectors" \
--header 'Content-Type: application/json' \
--data "@connector_pageviews.json"

printf "\n********** Creating datagen users **********************\n"
curl -s -X POST "http://$DATAGEN_URL/connectors" \
--header 'Content-Type: application/json' \
--data "@connector_users.json"

printf "\n\n********** Done **********************\n"
