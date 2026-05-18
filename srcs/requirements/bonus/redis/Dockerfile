FROM alpine:3.19

RUN apk update && apk add --no-cache redis

RUN sed -i 's/bind 127.0.0.1/bind 0.0.0.0/g' /etc/redis.conf && \
    sed -i 's/protected-mode yes/protected-mode no/g' /etc/redis.conf && \
    sed -i 's/^# requirepass foobared/requirepass redis123/g' /etc/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis.conf"]
