FROM bochen/datastax-base
MAINTAINER Piotr Bocheński <bochenski.piotr@gmail.com>

ENV OPS_VERSION 5.2.3

RUN apt-get download opscenter="$OPS_VERSION" \
	&& dpkg --unpack opscenter_"$OPS_VERSION"_all.deb \
	&& rm opscenter_"$OPS_VERSION"_all.deb \
	&& rm /var/lib/dpkg/info/opscenter.postinst \
	&& dpkg --configure --force-depends opscenter \
	&& apt-get install -f -y \
	&& rm -rf /var/lib/apt/lists/*

WORKDIR /usr/share/opscenter
EXPOSE 8888
CMD ["bin/opscenter", "-f"]
