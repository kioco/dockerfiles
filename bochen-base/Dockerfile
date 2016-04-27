FROM anapsix/alpine-java:jre8
MAINTAINER Piotr Bocheński <bochenski.piotr@gmail.com>

RUN apk add --update \
        bc \
        wget \
        net-tools

COPY java-wrapper.sh /usr/bin/java-wrapper
