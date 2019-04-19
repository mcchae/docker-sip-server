FROM ubuntu:18.04
MAINTAINER Jerry <mcchae@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
    && apt-get install -y \
        build-essential \
        openssl \
        libxml2-dev \
        libncurses5-dev \
		libnewt-dev \
		libedit-dev \
        uuid-dev \
        sqlite3 \
        libsqlite3-dev \
        pkg-config \
        libjansson-dev \
        libssl-dev \
		git \
		wget \
        curl \
        msmtp \
		tcpdump

## Asterisk expects /usr/sbin/sendmail
#RUN ln -s /usr/bin/msmtp /usr/sbin/sendmail
#
#ENV SRTP_VERSION 1.4.4
#RUN cd /tmp \
#    && curl -o srtp.tgz http://kent.dl.sourceforge.net/project/srtp/srtp/${SRTP_VERSION}/srtp-${SRTP_VERSION}.tgz \
#    && tar xzf srtp.tgz
#RUN cd /tmp/srtp* \
#    && ./configure CFLAGS=-fPIC \
#    && make \
#    && make install
#
#
#ENV ASTERISK_VERSION 14.5.0
#RUN cd /tmp && curl -o asterisk.tar.gz http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-${ASTERISK_VERSION}.tar.gz \
#    && tar xzf asterisk.tar.gz
#RUN cd /tmp/asterisk* \
#    && ./configure --with-pjproject-bundled --with-crypto --with-ssl --prefix=/ \
#    && make \
#    && make install \
#    && make samples \
#    && make config

#ENV ASTERISK_VERSION 14.5.0
RUN mkdir -p /usr/src && cd /usr/src \
	&& curl -O http://downloads.asterisk.org/pub/telephony/asterisk/asterisk-16-current.tar.gz \
    && tar xzf asterisk-16-current.tar.gz \
	&& cd asterisk-16*/ \
#	&& contrib/scripts/get_mp3_source.sh \
#	&& contrib/scripts/install_prereq install \
    && ./configure --with-pjproject-bundled --with-crypto --with-ssl --prefix=/ \
    && make \
    && make install \
    && make samples \
    && make config

RUN groupadd asterisk \
	&& useradd -r -d /var/lib/asterisk -g asterisk asterisk \
	&& usermod -aG audio,dialout asterisk \
	&& chown -R asterisk.asterisk /etc/asterisk \
	&& mkdir -p /var/{lib,log,spool}/asterisk \
	&& chown -R asterisk.asterisk /var/{lib,log,spool}/asterisk \
	&& mkdir -p /usr/lib/asterisk \
	&& chown -R asterisk.asterisk /usr/lib/asterisk
	
COPY asterisk /etc/default/asterisk
COPY asterisk.conf /etc/asterisk/asterisk.conf

USER asterisk

CMD asterisk -fvvv
