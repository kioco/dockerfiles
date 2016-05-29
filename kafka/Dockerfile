FROM bochen/bochen-base

ENV SCALA_VERSION 2.11
ENV KAFKA_VERSION 0.10.0.0
ENV KAFKA_TMP /tmp/kafka_$SCALA_VERSION-$KAFKA_VERSION
ENV KAFKA_HOME /opt/kafka

RUN wget -q -O - https://archive.apache.org/dist/kafka/$KAFKA_VERSION/kafka_$SCALA_VERSION-$KAFKA_VERSION.tgz | tar -xzf - -C /tmp &&\
    mkdir -p $KAFKA_HOME/bin $KAFKA_HOME/config &&\
    mv $KAFKA_TMP/libs $KAFKA_HOME/ &&\
    mv $KAFKA_TMP/bin/kafka-run-class.sh $KAFKA_HOME/bin/ &&\
    mv $KAFKA_TMP/bin/zookeeper-shell.sh $KAFKA_HOME/bin/ &&\
    mv $KAFKA_TMP/config/tools-log4j.properties $KAFKA_HOME/config/ &&\
    mv $KAFKA_TMP/config/server.properties $KAFKA_HOME/config/ &&\
    rm -r $KAFKA_TMP

WORKDIR $KAFKA_HOME
COPY docker-entrypoint.sh bin/
COPY log4j.properties config/

VOLUME ["/tmp/kafka-logs"]
EXPOSE 9092

ENTRYPOINT ["bin/docker-entrypoint.sh"]
CMD ["java-wrapper", "-cp", "config:libs/*:.", "kafka.Kafka", "config/server.properties"]
