#!/bin/bash
# run this AFTER the Kafka cluster is up AND the Monitoring cluster is up
# 
# it creates the pageviews and users topics and runs the generators

if ! command -v jq &> /dev/null
then
    printf "jq required and could not be found\n"
    printf "try 'sudo apt-get install jq'\n"
    printf "exiting\n"
    exit
fi

REST_PROXY_URL="localhost:8082/v3"

# derived from https://docs.confluent.io/current/kafka-rest/api.html#crest-api-v3
CLUSTER_IDENTITY=`curl -s -X GET "$REST_PROXY_URL/clusters"| jq '.data[0].id' | sed 's-crn:///kafka=--' | sed 's/"//g' `
if [ -z "$CLUSTER_IDENTITY"] 
then
  printf "cluster not found.  is it up?\n"
  printf "exiting\n"
  exit
fi
printf "cluster identity is: $CLUSTER_IDENTITY"
printf "\n"
TOPICS=`curl -s -X GET $REST_PROXY_URL/clusters/$CLUSTER_IDENTITY/topics`

printf "\n********** Creating topic pageviews **********************\n"
curl -s -X POST "http://$REST_PROXY_URL/clusters/$CLUSTER_IDENTITY/topics" \
--header 'Content-Type: application/vnd.api+json' \
--data "@topic_pageviews.json"

printf "\n********** Creating topic users **********************\n"
curl -s -X POST "http://$REST_PROXY_URL/clusters/$CLUSTER_IDENTITY/topics" \
--header 'Content-Type: application/vnd.api+json' \
--data "@topic_users.json"

printf "\n\n********** Done **********************\n"
