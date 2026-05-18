FROM alpine:3.19
RUN apk update && apk add nginx openssl netcat-openbsd

RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/C=MR/ST=1337/L=FLHALA/O=1337/CN=mtarza.42.fr"

RUN rm -f /etc/nginx/http.d/default.conf

COPY conf/nginx.conf /etc/nginx/http.d/default.conf
COPY tools/entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 443

ENTRYPOINT ["/entrypoint.sh"]
