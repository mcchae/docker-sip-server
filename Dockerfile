FROM ubuntu:16.04
MAINTAINER Jerry <mcchae@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        libxml2-dev \
        libncurses5-dev \
		libnewt-dev \
		libedit-dev \
        libsqlite3-dev \
        libjansson-dev \
        libssl-dev \
        libtool \
        sqlite \
		autoconf \
		automake \
		git-core \
		subversion \
		wget \
		net-tools \
		tcpdump

#ENV ASTERISK_VERSION 15.7.2
ENV ASTERISK_VERSION 15.7.3
RUN cd /usr/src \
	&& wget http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-${ASTERISK_VERSION}.tar.gz \
    && tar -zxvf asterisk-${ASTERISK_VERSION}.tar.gz \
	&& cd asterisk-${ASTERISK_VERSION} \
	&& sed -e 's/apt-get install aptitude/apt-get install -y aptitude/g'  ./contrib/scripts/install_prereq > /tmp/foo \
	&& chmod +x /tmp/foo \
	&& mv /tmp/foo ./contrib/scripts/install_prereq \
	&& ./contrib/scripts/install_prereq install \
    && ./configure --disable-xmldoc \
    && make \
    && make install \
    && make samples \
    && make config

CMD asterisk -fvvv
