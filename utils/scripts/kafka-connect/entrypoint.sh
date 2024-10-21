#!/bin/bash

# Verifica se o parâmetro foi passado
CREATE_CONNECTORS=false

if [ "$1" == "createConnectors" ]; then
  CREATE_CONNECTORS=true
fi

echo "Waiting for Kafka to be ready..."
while ! nc -z kafka-broker-df 29092; do   
  sleep 0.1
done
echo "Kafka is ready!"

/opt/kafka/kafka_connect_run.sh &

echo "Waiting for Kafka Connect REST API to be available..."
until curl --output /dev/null --silent --head --fail -X GET http://localhost:8083/connectors/; do
  sleep 5
done
echo "Kafka Connect REST API is available!"

# Cria conectores se o parâmetro for passado
if $CREATE_CONNECTORS; then
  for connector in /etc/kafka-connect/connectors/*.json; do
    echo "Registering connector: $connector"
    curl -X PUT -H "Content-Type: application/json" --data @$connector http://localhost:8083/connectors/$(basename $connector .json)/config
  done
fi

wait

