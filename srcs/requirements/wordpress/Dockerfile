FROM alpine:3.19

RUN apk update && apk add \
    php83 \
    php83-fpm \
    php83-mysqli \
    php83-curl \
    php83-iconv \
    php83-mbstring \
    php83-xml \
    php83-phar \
    php83-json \
    php83-openssl \
    php83-tokenizer \
    php83-session \
    php83-ctype \
    wget \
    curl \
    tar \
    netcat-openbsd

RUN ln -s /usr/bin/php83 /usr/bin/php

RUN adduser -S www-data -G www-data

RUN mkdir -p /var/www/wordpress

RUN wget https://wordpress.org/latest.tar.gz -O /tmp/wordpress.tar.gz && \
    tar -xzf /tmp/wordpress.tar.gz -C /var/www && \
    rm /tmp/wordpress.tar.gz && \
    chown -R www-data:www-data /var/www/wordpress

COPY conf/www.conf /etc/php83/php-fpm.d/www.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]
