FROM alpine:3.19

RUN apk update && apk add mariadb mariadb-client

RUN mkdir -p /run/mysqld && \
    mkdir -p /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql

COPY conf/my.cnf /etc/my.cnf
COPY tools/init.sh /usr/local/bin/init.sh

RUN chmod +x /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["/usr/local/bin/init.sh"]
