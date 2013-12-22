# Minecraft Server: Base
#
# VERSION 1.0.0
FROM stackbrew/ubuntu:saucy
MAINTAINER Paul Buonopane <paul+docker@earth2me.com>

RUN apt-get update
RUN apt-get install -y openjdk-7-jre-headless curl

RUN mkdir -p /mc/{server,control,tmp}

RUN useradd -UM -c 'Minecraft Server' -d /mc/server -s /bin/bash
RUN chown -R mc:mc /mc
RUN chmod -R 2770 /mc