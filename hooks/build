#!/bin/bash
# A copy of this file is in the hooks folder for DockerHub bilds
# A copy of this file is in the top level directory for humans

CONFLUENT_VERSION="5.5.1"
JOLOKIA_VERSION="1.6.2"
TIMESTAMP=$(date +%Y%m%d%H%M%S) 
echo "Basing this on kafka version: $CONFLUENT_VERSION and Jolokia version: $JOLOKIA_VERSION"
# Our version matches the Kafka version we build from
docker build \
    --tag freemansoft/cp-server:$CONFLUENT_VERSION \
    --tag freemansoft/cp-server:$CONFLUENT_VERSION-$TIMESTAMP \
    --tag freemansoft/cp-server:latest \
    --build-arg CONFLUENT_VERSION=$CONFLUENT_VERSION \
    --build-arg JOLOKIA_VERSION=$JOLOKIA_VERSION \
    .
