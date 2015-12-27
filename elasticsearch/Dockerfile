FROM java:8-jre
MAINTAINER Piotr Bocheński <bochenski.piotr@gmail.com>

ENV ES_VERSION 2.1.1
ENV ES_HOME /usr/share/elasticsearch

RUN echo "deb http://packages.elastic.co/elasticsearch/2.x/debian stable main" > /etc/apt/sources.list.d/elasticsearch.list \
	&& echo "deb http://packages.elastic.co/curator/3/debian stable main" > /etc/apt/sources.list.d/curator.list \
	&& wget -qO - https://packages.elastic.co/GPG-KEY-elasticsearch | apt-key add - \
	&& apt-get update \
	&& apt-get install -y --no-install-recommends elasticsearch=$ES_VERSION python-elasticsearch-curator \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR $ES_HOME
RUN mkdir config data logs

COPY docker-entrypoint.sh bin/
COPY elasticsearch.yml config/
COPY logging.yml config/

RUN chown -R elasticsearch: config data logs
USER elasticsearch

VOLUME ["/usr/share/elasticsearch/data"]
EXPOSE 9200 9300

ENTRYPOINT ["bin/docker-entrypoint.sh"]
CMD ["bin/elasticsearch"]
