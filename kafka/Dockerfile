FROM bochen/bochen-base

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.9.0.1
ENV KAFKA_TMP /tmp/kafka_$SCALA_VERSION-$KAFKA_VERSION
ENV KAFKA_HOME /opt/kafka

RUN wget -q -O - http://mirrors.ibiblio.org/apache/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | tar -xzf - -C /tmp &&\
    mkdir -p $KAFKA_HOME/{bin,config} &&\
    mv $KAFKA_TMP/libs $KAFKA_HOME/ &&\
    mv $KAFKA_TMP/bin/zookeeper-shell.sh $KAFKA_HOME/bin/ &&\
    mv $KAFKA_TMP/config/server.properties $KAFKA_HOME/config/ &&\
    rm -r $KAFKA_TMP

WORKDIR $KAFKA_HOME
COPY docker-entrypoint.sh bin/
COPY log4j.properties config/

VOLUME ["/tmp/kafka-logs"]

ENV JVM_ENABLE_JMX true
EXPOSE 9092 9999

ENTRYPOINT ["bin/docker-entrypoint.sh"]
CMD ["java-wrapper", "-cp", "libs/*:config:.", "kafka.Kafka", "config/server.properties"]
