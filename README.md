This project exposes _Kafka Topic_ metrics via JMX where they are picked up and stored in InfluxDB and exposed to user via Grafana.

Kakfa Brokers expose topic statistics two ways
* JMX Beans
* As messages in  _confluent-metrics_ topic

-----------------
## confluent-cp 2/ Jolokia Docker Image
This project builds a Docker image on top of the _confluentinc/cp-server_ docker iamage. 
The Image exposes the Jolokia HTTP endpoint on port  ``` 8778 ```.
The Image will receive two tags, the cp-server version and the cp-serverversion appeneded with the build timestamp.
This lets start scripts use the same version number for this cp-server as it does for the rest of the confluent components.
You must run the _freemansoft/cp-server_ with these parameters to enable the Jolokia agent installed in this image.
> KAFKA_OPTS: '-javaagent:/opt/jolokia/jolokia-jvm-agent.jar=host=0.0.0.0'

You configure the Telegraf _Jolokia2_ plugin to use this endpoint as input where it can then be sent to any Telegraf output sink. See the sample telegraf.conf file in this GitHub repo associated with this Docker Image

### Building this Docker Image
* Build a docker container that includes the Jolokia agent that exposes JMX over HTTP on port.
* cd into that directory
    * >cd jolokia
    * >build.sh
    * >docker-compose up
-----------------
## Sample _telegraf.conf_ file.
Jolokia exposes about 3000 metrics. The sample _telegraf.conf_ file imports a reasonable portion of these.
The file is configured as:
* Poll the kafka broker nodes every 20 seconds instead of 10 seconds. This cuts the amount of data collected in half. The default seems excessive for metrics.
* Increase tinput buffer sizes 4x from the default.  The defaults are overrun by 7000 metrics when connected to three servers at the default buffer size.  This implies 17000 metrics.  The buffer sizes are now 4000/40000 which shold be twice what we need for a 3 node.  _I just guessed at all that_
* Push the data to a Containerized InfluxDB database

-----------------
# Exercising this repository
![Demo Cluster](docs/Kafka-Jolokia-Topology.png)
## Run the Kafka cluster and the Monitoring cluster
This project builds on a Docker Image built on top of the standard _confluentinc/cp-server_ docker image
1. Build a Kafka Broker Docker image with the _Jolokia_ Agent
    *  ``` bash build.sh ```
2. Start Kafka
    *  ```docker-compose -f docker-compose-kafka.yml```
3. Verify *Kakfa* is up by looking at the _Confluent Dashboard_
    * http://localhost:9021/clusters/
3. Verify the *Jolokia Agent) is coughing up JMX bean data. * Jolokia port 8778 is exposed to the docker host in the docker_compose sample.
This will show all the beans available exposed by the _Kafka Broker_
All MBean data is exposed to the Jolokia REST endpoint. Topic statistics should exist for each topic. 
Browse to the _Jolokia REST Endpoint_
    * http://localhost:8778/jolokia/list
4. Start the monitoring ecosystem - Telegraf, InfluxDB and Grafana
    * ```docker-compose -f docker-compose-monitoring.yml```
5. Verify the _Grafana_ UI is up.  The credentials are _admin/admin_ Browse to the _Grafana UI_
    * http://localhost:3000/login 

-----------------
## Generate Test data in Kafka using Datagen
See this page >https://docs.confluent.io/current/quickstart/ce-quickstart.html The following is a poor cheatsheet
1. Open Browser to the _Confluent Dashboard_
    *  http://localhost:9021/clusters/ 
1. Create a topic named _pageviews_
    *  ```Cluster1 --> Topics --> _+ Add a Topic_ --> name it _pageviews_ --> Press _Create with Defaults_ ```
1. Create a topic named _users_
    *  ```Cluster1 --> Topics --> _+ Add a Topic_ --> name it _users_ --> Press _Create with Defaults_ ```
1. Generate test data using the console and the datagen source
    * pageviews 
      1. Connect to Web Console
      1. Connect to Datagen Connector
          * Connect ```Clusters > Connect> connect-default >```
          * You will be on the connectors page
          * Press _Add Connector_ on the right
          * Find then button _DatagenConnector_ press _Connect_
      1. Set the name to _datagent-pageviews_
      1. On the next page _Add Connector_
          * Key converter class field, -> org.apache.kafka.connect.storage.StringConverter.
          * kafka.topic field ->  pageviews.
          * max.interval field ->  100. 
          * quickstart field ->  pageviews.
      1. Click Continue
      1. Review the connector configuration and click _launch_
    * users 
      1. Connect to Web Console
          * Connect ```Clusters > Connect> connect-default >``
          * You will be on the connectors page
          * Press _Add Connector_ on the right
          * Find the button _DatagenConnector_ press _Connect_
      1. Set the name to _datagen-users_
      1. On the next page _Add Connector_
          * Key converter class field, -> org.apache.kafka.connect.storage.StringConverter.
          * kafka.topic field ->  users
          * max.interval field ->  100 
          * quickstart field ->  users
      1. Click Continue
      1. Review the connector configuration and click _launch_
1. Verify 2 the two datagen connectors running
    * ```Cluster 1 --> connect --> connect-default```
 
-----------------
## Configure Grafana
1. Connect to the _Grafana Dashboard_
    * http://localhost:3000/login
    * admin/admin
    * skip the offered password change
1. Click on _add data source_
1. Click on influxDB to start the connection creation
1. Create a data source that points at _InfluxDB_
    * Url:  http://influxdb:8086
    * Database: telegraf
    * Leave everything else blank
1. Click _Save and Test_

You can view the datasource configuration via the _Grafana REST API_
   http://localhost:3000/api/datasources/ 

## Run Grafana Queries
1. Connect to the _Grafana Dashboard_ with your browser as described above
1. In the Grafana dashboard
    * Click on _Explore_ in the left menu
1. Make sure the DB droplist at the top is set to _InfluxDB_
1. On the _FROM_ line
    * Change the from to the desired metric like _cpu_ or _kafka\_topics_
1. On the _Select_ line
    * Change the field value to the metric you want to see
1. Click on _Run Query_

Example: __FROM__ _default_ _mem_ __WHERE__ __SELECT__ field(active) mean() __GROUP BY__ time($_interval...) _FORMAT AS_ Time series

-----------------
## Cleanup 
1. Bring down monitoring
  * ```docker-compose -f docker-compose-monitory.yml down ```
1. Bring down kafka
  * ```docker-compose -f docker-compose-kafka.yml down ```
3. If you only control-c the open windows then you may need
  * ```docker container prune ```

-----------------
## References used creating ths project
* See _sample-jolokia-beans.json_ for all the mbean data coughed up by Jolokia for a unadulterated Kafka broker
* Jolokia / Telegraf sample config https://telegraf-kafka.readthedocs.io/en/stable/kafka_monitoring.html
* Jolokia / Telegraf sample config https://docs.wavefront.com/kafka.html
* Datagen data generator demo https://docs.confluent.io/current/quickstart/ce-quickstart.html

-----------------
### Grafana API
You should be abel to Create a grafana database confguration by sending a POST to http://localhost:3000/api/datasources
```
{
  "name": "InfluxDB",
  "type": "influxdb",
  "url": "http://influxdb:8086",
  "database": "telegraf",
}
```
@see https://grafana.com/docs/grafana/latest/http_api/data_source/

