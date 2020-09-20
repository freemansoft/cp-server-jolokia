## quickstart
Scripts in this folder let you run the Kafka quick start.
* Create users and pagviews topics
* Create the quickstart data generator as a kafka connector.
* Use the quickstart user/pageview data generator to create traffic Kafka traffic
* Create a Grafana database source that points at the metrics in influxdb
* Create a Grafana dashboard that displayes a couple metrics.

## Prerequisites
* Kakfa is running locally in Docker.
    *  mostly likely using the docker-compose yml in the root folder of this project
* InfluxDB and Grafana are running locally in Docker
    *  mostly likely using the docker-compose yml in the root folder of this project

## Demo Docker Cluster Topology
The deployed cluster looks like

![Demo Cluster](../docs/Kafka-Jolokia-Topology.png)

## Generating Data and Dashboards
The following steps use the REST APIs provided by Apache Kafka, the Kafka Connector and Grafana

| Step | Command |
| ---- | ------- |
| Open terminal and cd into quickstart folder | | 
| Create the topics | run ```bash 1_create_topics.sh```
| Create the quick start data generators so they can start creating data | run ```bash 2_create_and_run_generators.sh```
| Create the Grafana data source and dashboard | run ```bash 3_create_grafana_datasource_dashboards.sh```

### Monitoring
1. Open the Grafana engine to see metrics http://localhost:3000/?orgId=1
    * admin/admin in the example environment
1. Open the Confluence console to see the topics http://localhost:9021/clusters

## References
Data Generator JSON derived from 
* https://github.com/confluentinc/kafka-connect-datagen
* https://docs.confluent.io/current/quickstart/cos-quickstart.html

Kafka Topic JSON derived from 
* https://rmoff.net/2020/06/05/how-to-list-and-create-kafka-topics-using-the-rest-proxy-api/
* https://docs.confluent.io/5.3.1/connect/references/restapi.html

Grafana API
* https://grafana.com/docs/grafana/latest/http_api/auth/
* https://grafana.com/docs/grafana/latest/http_api/data_source/
* https://grafana.com/docs/grafana/latest/http_api/dashboard/

