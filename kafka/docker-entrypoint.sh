#!/bin/bash

export IP=$(hostname -i)
export SERVER_PROPS="config/server.properties"

function ip_hash() {
  hash=$(md5sum <<< "$1" | cut -b 1-6)
  echo $((0x${hash%% *}))
}

if [[ -n "${KAFKA_XMX}" ]] && [[ -n "${KAFKA_XMS}" ]] ; then
  sed -i "s/-Xmx1G -Xms1G/-Xmx"${KAFKA_XMX}" -Xms"${KAFKA_XMS}"/g" "bin/kafka-server-start.sh"
fi

if [[ -z "${KAFKA_ZOOKEEPER_CONNECT}" ]]; then
  export KAFKA_ZOOKEEPER_CONNECT=$(./bin/zookeeper-shell.sh zk:2181 <<< 'get /zookeeper/config' | grep ^server. | awk -F '[=:]' '{print $2":"$6}' | awk '$1=$1' RS= OFS=,)
fi

if [[ -z "${KAFKA_BROKER_ID}" ]]; then
  export KAFKA_BROKER_ID=$(ip_hash ${IP})
fi

if [[ -z "${KAFKA_ADVERTISED_HOST_NAME}" ]]; then
  export KAFKA_ADVERTISED_HOST_NAME=${IP}
fi

if [[ -z "${KAFKA_LOG_DIRS}" ]]; then
  export KAFKA_LOG_DIRS="/tmp/kafka-logs/broker-$KAFKA_BROKER_ID"
fi

export KAFKA_AUTO_LEADER_REBALANCE_ENABLE=true
export KAFKA_DELETE_TOPIC_ENABLE=true

for VAR in `env`
do
  if [[ ${VAR} =~ ^KAFKA_ && ! ${VAR} =~ ^KAFKA_HOME && ! ${VAR} =~ ^KAFKA_VERSION && ! ${VAR} =~ ^KAFKA_XM ]]; then
    kafka_name=`echo "$VAR" | sed -r "s/KAFKA_(.*)=.*/\1/g" | tr '[:upper:]' '[:lower:]' | tr _ .`
    env_var=`echo "$VAR" | sed -r "s/(.*)=.*/\1/g"`
    if egrep -q "(^|^#)$kafka_name=" ${SERVER_PROPS}; then
      sed -r -i "s@(^|^#)($kafka_name)=(.*)@\2=${!env_var}@g" ${SERVER_PROPS}
    else
      echo "$kafka_name=${!env_var}" >> ${SERVER_PROPS}
    fi
  fi
done

export KAFKA_JMX_OPTS="-Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false -Djava.rmi.server.hostname="${IP}" -Dcom.sun.management.jmxremote.port=9898 -Dcom.sun.management.jmxremote.rmi.port=9898"
exec "$@"
