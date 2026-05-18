FROM alpine:3.19


RUN apk update && apk add --no-cache \
    php83 \
    php83-mysqli \
    php83-session \
    php83-json \
    wget

RUN mkdir -p /var/www/html

RUN wget -O /var/www/html/index.php https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php

RUN ln -s /usr/bin/php83 /usr/bin/php

WORKDIR /var/www/html

EXPOSE 8080

CMD ["php", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]
