# Nginx and PHP-FPM
#
# Volumes are /conf and /log. Put your per-instance configuration files in
# /conf; for shared configuration files, use /etc/nginx and /etc/php5.
# Unfortunately, there's no include directive in php.ini, so there's no
# /conf/php5-fpm directory.
#
# VERSION 1.0.0
FROM stackbrew/ubuntu:saucy
MAINTAINER Paul Buonopane <paul+docker@earth2me.com>

VOLUME [ "/conf", "/log" ]

# Ensure that we are up-to-date
RUN apt-get update
RUN apt-get dist-upgrade -y

RUN apt-get install -y nginx php5-fpm

# Use volumes
RUN mkdir -p /conf/nginx /log/nginx /log/php5-fpm
RUN rm -Rf /etc/nginx/sites-enabled/default /var/log/nginx /var/log/php5-fpm
RUN echo 'include /conf/nginx/*;' > /etc/nginx/conf.d/docker.conf
RUN ln -s /log/nginx /var/log/nginx
RUN ln -s /log/php5-fpm /var/log/php5-fpm

# Common extensions
RUN apt-get install -y php-pear php5-json php5-mysqlnd php5-gd

# Run in foreground
CMD php5-fpm -FR & nginx -g "daemonize off;" & wait
