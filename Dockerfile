FROM alpine
MAINTAINER Chris Gentle <chris@flatmapit.com>
# Homage: MAINTAINER Russ McKendrick <russ@mckendrick.io>
# Homage: https://github.com/CentOS/CentOS-Dockerfiles/blob/master/mariadb/centos7
# Homage: https://github.com/russmckendrick/docker/blob/master/mariadb


ENV TERM dumb

ADD run /usr/local/bin/
ADD dump /usr/local/bin/
RUN apk add  -U mysql mariadb-client bash && \
	rm -rf /var/cache/apk/* && \
    mkdir -p /var/lib/mysql && \
    mkdir -p /etc/mysql/conf.d && \
    mkdir -p /run/mysqld/ && \
    { \
        echo '[mysqld]'; \
        echo '#user = root'; \
        echo 'datadir = /var/lib/mysql'; \
        echo 'port = 3306'; \
        echo 'log-bin = /var/lib/mysql/mysql-bin'; \
        echo '!includedir /etc/mysql/conf.d/'; \
    } > /etc/mysql/my.cnf && \
    chmod +x /usr/local/bin/run && chmod +x /usr/local/bin/dump

#COPY docker-entrypoint.sh /

# Fix permissions to allow for running on openshift
COPY fix-permissions.sh ./
#     ./fix-permissions.sh /var/log/mariadb/ && \
RUN ./fix-permissions.sh /var/lib/mysql/   && \
    ./fix-permissions.sh /var/run/ &&\
    ./fix-permissions.sh /run

USER 27

EXPOSE 3306
CMD ["/usr/local/bin/run"]
