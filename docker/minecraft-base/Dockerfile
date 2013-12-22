# Minecraft Server: Base
#
# VERSION 1.0.0
FROM stackbrew/ubuntu:saucy
MAINTAINER Paul Buonopane <paul+docker@earth2me.com>

RUN mkdir -p /mc/{control}

VOLUME [ "/mc/tmp", "/mc/server" ]

RUN apt-get update
RUN apt-get install -y openjdk-7-jre-headless curl

RUN useradd -UM -c 'Minecraft Server' -d /mc/server -s /bin/bash
RUN chown -R mc:mc /mc
RUN chmod -R 2770 /mc