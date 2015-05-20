FROM ubuntu:14.04

ENV DEBIAN_FRONTEND noninteractive

RUN locale-gen en_US en_US.UTF-8

RUN apt-get -q update
RUN apt-mark hold initscripts udev plymouth mountall
RUN apt-get -qy --force-yes dist-upgrade

RUN apt-get install -qy --force-yes curl wget dpkg avahi-daemon avahi-utils

RUN wget -O /tmp/plex.deb https://downloads.plex.tv/plex-media-server/0.9.9.14.531-7eef8c6/plexmediaserver_0.9.9.14.531-7eef8c6_amd64.deb
RUN dpkg -i /tmp/plex.deb
RUN service plexmediaserver restart

VOLUME /config
VOLUME /data

ADD ./start.sh /start.sh
RUN chmod u+x  /start.sh

EXPOSE 32400

ENTRYPOINT ["/start.sh"]
