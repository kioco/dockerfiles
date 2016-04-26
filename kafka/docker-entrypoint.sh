#!/usr/bin/env bash
set -e

SERVER_PROPS="config/server.properties"

if [[ -z "${KAFKA_ZOOKEEPER_CONNECT}" ]]; then
  KAFKA_ZOOKEEPER_CONNECT=$(./bin/zookeeper-shell.sh zk:2181 <<< 'get /zookeeper/config' | grep ^server. | awk -F '[=:]' '{print $2":"$6}' | awk '$1=$1' RS= OFS=,)
fi

if [[ -z "${KAFKA_BROKER_ID}" ]]; then
  KAFKA_BROKER_ID=-1
fi

if [[ -z "${KAFKA_ADVERTISED_HOST_NAME}" ]]; then
  KAFKA_ADVERTISED_HOST_NAME=$(hostname -i | awk '{print $1}')
fi

KAFKA_AUTO_LEADER_REBALANCE_ENABLE=true
KAFKA_DELETE_TOPIC_ENABLE=true

for VAR in $(set)
do
  if [[ ${VAR} =~ ^KAFKA_ ]]; then
    kafka_name=$(echo "$VAR" | sed -r "s/KAFKA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .)
    env_var=$(echo "$VAR" | sed -r "s/(.*)=.*/\1/g")
    if egrep -q "(^|^#)$kafka_name=" ${SERVER_PROPS}; then
      sed -r -i "s@(^|^#)($kafka_name)=(.*)@\2=${!env_var}@g" ${SERVER_PROPS}
    else
      echo "$kafka_name=${!env_var}" >> ${SERVER_PROPS}
    fi
  fi
done

export JVM_OPTS="-XX:MaxGCPauseMillis=20 -XX:InitiatingHeapOccupancyPercent=35"
exec "$@"
