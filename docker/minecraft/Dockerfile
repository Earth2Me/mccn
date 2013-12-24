# Minecraft Server
#
# VERSION 1.0.0
FROM stackbrew/ubuntu:saucy
MAINTAINER Paul Buonopane <paul+docker@earth2me.com>

ADD filesystem/mc mc

RUN apt-get update
RUN apt-get install -y openjdk-7-jre-headless curl rdiff-backup

RUN useradd -UM -c 'Minecraft Server' -d /mc/server -s /bin/bash
RUN chown -R mc:mc /mc
RUN chmod -R 2770 /mc

VOLUME [ "/mc/tmp", "/mc/server" ]

RUN chmod ug+x /mc/control/run.sh
ENTRYPOINT [ "/mc/control/run.sh" ]
