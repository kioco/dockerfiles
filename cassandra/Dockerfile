FROM bochen/datastax-base
MAINTAINER bochen

ENV CASSANDRA_VERSION 3.0.1
ENV AGENT_VERSION 5.2.3
ENV CASSANDRA_CONFIG /etc/cassandra

ENV CASSANDRA_XMS 128M
ENV CASSANDRA_XMX 512M

RUN apt-get install -y \
		sysstat \
		sudo \
		supervisor \
		dsc30="$CASSANDRA_VERSION"-1 \
		datastax-agent="$AGENT_VERSION" \
	&& rm -rf /var/lib/apt/lists/*

COPY docker-entrypoint.sh /
COPY supervisord.conf /etc/supervisor/conf.d/
COPY logback.xml $CASSANDRA_CONFIG/

ENTRYPOINT ["/docker-entrypoint.sh"]
VOLUME ["/var/lib/cassandra"]

EXPOSE 7000 7001 7199 9042 9160
CMD ["/usr/bin/supervisord"]
