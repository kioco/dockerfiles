FROM bochen/storm-base:0.10.0
MAINTAINER Piotr Bocheński <bochenski.piotr@gmail.com>

RUN /usr/bin/config-supervisord.sh supervisor

EXPOSE 6700 9797
CMD /usr/bin/start-supervisor.sh
