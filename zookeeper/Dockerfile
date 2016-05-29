FROM bochen/bochen-base

ENV ZK_VERSION 3.5.1-alpha
ENV ZK_TMP /tmp/zookeeper-$ZK_VERSION
ENV ZK_HOME /opt/zookeeper

RUN wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-$ZK_VERSION/zookeeper-$ZK_VERSION.tar.gz | tar -xzf - -C /tmp &&\
    mkdir -p $ZK_HOME/bin $ZK_HOME/conf &&\
    mv $ZK_TMP/lib $ZK_HOME/ &&\
    mv $ZK_TMP/zookeeper-$ZK_VERSION.jar $ZK_HOME/ &&\
    ln $ZK_HOME/zookeeper-$ZK_VERSION.jar $ZK_HOME/lib/zookeeper.jar &&\
    mv $ZK_TMP/bin/zkEnv.sh $ZK_HOME/bin/ &&\
    mv $ZK_TMP/bin/zkServer-initialize.sh $ZK_HOME/bin/ &&\
    mv $ZK_TMP/bin/zkCli.sh $ZK_HOME/bin/ &&\
    mv $ZK_TMP/conf/zoo_sample.cfg $ZK_HOME/conf/zoo.cfg &&\
    rm -r $ZK_TMP

WORKDIR $ZK_HOME
COPY docker-entrypoint.sh bin/
COPY log4j.properties conf/

VOLUME ["/tmp/zookeeper"]
EXPOSE 2181 2888 3888

ENTRYPOINT ["bin/docker-entrypoint.sh"]
CMD ["java-wrapper", "-cp", "conf:lib/*:.", "org.apache.zookeeper.server.quorum.QuorumPeerMain", "./conf/zoo.cfg"]
