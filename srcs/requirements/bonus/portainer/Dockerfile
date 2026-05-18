FROM alpine:3.19

RUN apk update && apk add --no-cache wget ca-certificates

RUN wget -O /portainer.tar.gz https://github.com/portainer/portainer/releases/download/2.33.0/portainer-2.33.0-linux-amd64.tar.gz && \
    tar -xzf /portainer.tar.gz -C / && \
    rm /portainer.tar.gz

RUN mkdir -p /data

EXPOSE 9443

ENTRYPOINT ["/portainer/portainer"]
CMD ["--data", "/data"]
