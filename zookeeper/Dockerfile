FROM java:8-jre
MAINTAINER bochen

ENV ZK_VERSION 3.5.1-alpha
ENV ZK_HOME /opt/zookeeper-$ZK_VERSION
ENV JMXPORT 9696

RUN apt-get update \
	&& apt-get install -y net-tools \
	&& rm -rf /var/lib/apt/lists/* \
	&& wget -q -O - http://apache.mirrors.pair.com/zookeeper/zookeeper-$ZK_VERSION/zookeeper-$ZK_VERSION.tar.gz | tar -xzf - -C /opt \
	&& mv $ZK_HOME/conf/zoo_sample.cfg $ZK_HOME/conf/zoo.cfg \
	&& mkdir -p /tmp/zookeeper

WORKDIR $ZK_HOME
COPY docker-entrypoint.sh bin/
COPY start-zk.sh bin/
COPY log4j.properties conf/

VOLUME ["/tmp/zookeeper"]
EXPOSE 2181 2888 3888 9696

ENTRYPOINT ["bin/docker-entrypoint.sh"]
CMD ["bin/start-zk.sh"]
